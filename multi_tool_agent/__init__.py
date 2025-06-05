import asyncio
import re
import sys
import argparse
from dotenv import load_dotenv
from math import ceil

from google.adk.agents import LoopAgent, SequentialAgent
from google.adk.sessions import InMemorySessionService, DatabaseSessionService, Session
from google.adk.runners import Runner
from google.genai.types import Content, Part
from multi_tool_agent.events_extractor_manager_agent.agents.event_extractor_manager_agent import (
    event_extractor_manager_agent,
)
from multi_tool_agent.events_extractor_manager_agent.agents.remove_duplicate_events_agent import (
    remove_duplicate_events_agent,
)
from multi_tool_agent.events_extractor_manager_agent.agents.store_events_in_db_agent import (
    store_events_in_db_agent,
)
from multi_tool_agent.events_extractor_manager_agent.agents.end_extraction_agent import (
    end_extraction_agent,
)
from utils.file_reader import FileReader

from config import APP_NAME, USER_ID


def get_last_page_number(text: str):
    matches = re.findall(r"<!-- page: (\d+) -->", text)
    return int(matches[-1]) if matches else 0


async def main():
    parser = argparse.ArgumentParser(
        prog="EventsExtractor",
        description="Extract all events from a markdown document and store them inside a database",
    )
    parser.add_argument(
        "md_input_file", help="Markdown file containing the events to extracts"
    )
    parser.add_argument(
        "-db",
        "--session-database",
        help="Base de données stockant les conversations des agents",
        default=None,
    )
    parser.add_argument(
        "-sid",
        "--session-id",
        help="Id d'une session EXISTANTE afin de reprendre la conversation",
        default=None,
    )
    parser.add_argument(
        "-edb",
        "--events-db-path",
        help="Fichier dans lequelle sont stockés les events au format json.",
        default="events.json",
    )
    parser.add_argument("-v", "--verbose", action="store_true", default=False)
    args = parser.parse_args()

    document_content = FileReader().readFile(args.md_input_file)
    total_doc_pages = get_last_page_number(document_content)
    if total_doc_pages == 0:
        return sys.exit("Erreur : Le document ne contient pas de pages")

    session_service = None
    session: Session | None = None

    double_extraction_agent = LoopAgent(
        name="DoubleExtraction",
        description="Extrait 2 fois d'affilé les événements",
        sub_agents=[event_extractor_manager_agent],
        max_iterations=2,
    )

    root_agent = LoopAgent(
        name="ExtractEventsPipeline",
        sub_agents=[
            SequentialAgent(
                name="ExtractionIteration",
                sub_agents=[
                    double_extraction_agent,
                    remove_duplicate_events_agent,
                    store_events_in_db_agent,
                    end_extraction_agent,
                ],
            )
        ],
        max_iterations=ceil(total_doc_pages / 2),
    )

    if args.session_database is None:
        session_service = InMemorySessionService()
    else:
        session_service = DatabaseSessionService(
            db_url=f"sqlite:///{args.session_database}"
        )

    if args.session_database is not None and args.session_id is not None:
        session = await session_service.get_session(
            app_name=APP_NAME,
            user_id=USER_ID,
            session_id=args.session_id,
        )
    else:
        session = await session_service.create_session(
            app_name=APP_NAME,
            user_id=USER_ID,
            state={
                "source_doc": args.md_input_file,
                "total_doc_pages": total_doc_pages,
                "page_interval": "0-0",
                "extracted_events": [],
                "events_db_path": args.events_db_path,
            },
        )

    print(f"Session id : {session.id}")

    runner = Runner(
        agent=root_agent, app_name=APP_NAME, session_service=session_service
    )
    user_query = "Commence la recuperation de la timeline. Si une récupération été déjà en cours reprends là ou elle s'était arretée"

    content = Content(
        role="user",
        parts=[Part(text=user_query)],
    )

    events = runner.run_async(
        user_id=USER_ID, session_id=session.id, new_message=content
    )
    # NOTE: This sync interface is only for local testing and convenience purpose. Consider using run_async for production usage.

    async for event in events:
        print(f"Event from: {event.author}")
        # agent's complete output for a turn. Filtre les étapes intermédiaires
        # (les appels aux tools, les updates de state)
        # if event.is_final_response():
        if event.content and event.content.parts:
            if event.get_function_calls():
                print("  Type: Tool Call Request")
                calls = event.get_function_calls()
                if calls:
                    for call in calls:
                        tool_name = call.name
                        arguments = call.args  # This is usually a dictionary
                        print(f"  Tool: {tool_name}, Args: {arguments}")
                        # Application might dispatch execution based on this

            elif event.get_function_responses():
                print("  Type: Tool Result")
                for response in event.get_function_responses():
                    tool_name = response.name
                    result_dict = (
                        response.response
                    )  # The dictionary returned by the tool
                    print(f"  Tool Result: {tool_name} -> {result_dict}")

            elif event.content.parts[0].text:
                if event.partial:
                    print("  Type: Streaming Text Chunk")
                else:
                    print("  Type: Complete Text Message")
                    print(event.content.parts[0].text)
            elif (
                hasattr(event, "long_running_tool_ids") and event.long_running_tool_ids
            ):
                print("Tool is running in background...")
            else:
                print("  Type: Other Content (e.g., code result)")
        elif event.actions and (
            event.actions.state_delta or event.actions.artifact_delta
        ):
            print("  Type: State/Artifact Update")
        else:
            print("  Type: Control Signal or Other")


load_dotenv()
asyncio.run(main())
