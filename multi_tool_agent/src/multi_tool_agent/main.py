from google.adk.agents import LoopAgent
from google.adk.sessions import InMemorySessionService
from google.adk.runners import Runner
from google.genai.types import Content, Part
from events_extractor_agent.event_extractor import event_extractor_manager_agent

from config import APP_NAME, USER_ID, TOTAL_DOC_PAGES


def main():
    root_agent = LoopAgent(
        name="RefinementLoop",
        sub_agents=[
            event_extractor_manager_agent,
        ],
        max_iterations=TOTAL_DOC_PAGES,
    )

    session_service = InMemorySessionService.create_session(
        app_name=APP_NAME, user_id=USER_ID
    )
    runner = Runner(
        agent=root_agent, app_name=APP_NAME, session_service=session_service
    )
    user_query = "tu dois faire x"

    content = Content(
        role="user",
        parts=[Part(text=user_query)],
    )
    events = runner.run(new_message=content)
    # NOTE: This sync interface is only for local testing and convenience purpose. Consider using run_async for production usage.

    for event in events:
        if event.is_final_response():
            final_response = event.content.parts[0].text
            print("Agent Response: ", final_response)


if __name__ == "__main__":
    main()
