import asyncio
import re
import sys
import argparse
from dotenv import load_dotenv

from google.adk.agents import LoopAgent
from google.adk.sessions import InMemorySessionService
from google.adk.runners import Runner
from google.genai.types import Content, Part
from multi_tool_agent.events_extractor_manager_agent.agents.event_extractor_manager_agent import (
    event_extractor_manager_agent,
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
    parser.add_argument("-v", "--verbose", action="store_true", default=False)
    args = parser.parse_args()

    document_content = FileReader().readFile(args.md_input_file)
    total_doc_pages = get_last_page_number(document_content)
    if total_doc_pages == 0:
        return sys.exit("Erreur : Le document ne contient pas de pages")

    root_agent = LoopAgent(
        name="RefinementLoop",
        sub_agents=[
            event_extractor_manager_agent,
        ],
        max_iterations=total_doc_pages,
    )

    session_service = InMemorySessionService()
    session = await session_service.create_session(
        app_name=APP_NAME,
        user_id=USER_ID,
        state={
            "source_doc": args.md_input_file,
            "total_doc_pages": total_doc_pages,
            "page_interval": "[1-5]"
        },
    )
    runner = Runner(
        agent=root_agent, app_name=APP_NAME, session_service=session_service
    )
    user_query = "tu dois faire x"

    content = Content(
        role="user",
        parts=[Part(text=user_query)],
    )
    events = runner.run(user_id=USER_ID, session_id=session.id, new_message=content)
    # NOTE: This sync interface is only for local testing and convenience purpose. Consider using run_async for production usage.

    for event in events:
        if event.is_final_response():

            print(f"Event from: {event.author}")

            if event.content and event.content.parts:
                if event.get_function_calls():
                    print("  Type: Tool Call Request")
                    calls = event.get_function_calls()
                    if calls:
                        for call in calls:
                            tool_name = call.name
                            arguments = call.args # This is usually a dictionary
                            print(f"  Tool: {tool_name}, Args: {arguments}")
                            # Application might dispatch execution based on this
                    
                elif event.get_function_responses():
                    print("  Type: Tool Result")
                    for response in event.get_function_responses():
                        tool_name = response.name
                        result_dict = response.response # The dictionary returned by the tool
                        print(f"  Tool Result: {tool_name} -> {result_dict}")


                elif event.content.parts[0].text:
                    if event.partial:
                        print("  Type: Streaming Text Chunk")
                    else:
                        print("  Type: Complete Text Message")
                else:
                    print("  Type: Other Content (e.g., code result)")
            elif event.actions and (event.actions.state_delta or event.actions.artifact_delta):
                print("  Type: State/Artifact Update")
            else:
                print("  Type: Control Signal or Other")


load_dotenv()
asyncio.run(main())
