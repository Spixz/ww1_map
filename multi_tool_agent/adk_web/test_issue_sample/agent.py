from google.adk.agents import LlmAgent
from google.adk.tools import ToolContext
from pymongo import MongoClient
import os


def store_events_in_db(events: list[dict], tool_context: ToolContext) -> str:
    """Insert a list of event dicts into MongoDB."""
    tool_context.actions.skip_summarization = True
    try:
        mongo_uri = os.getenv("MONGO_URI") | "mongodb://localhost:27017"
        client = MongoClient(os.getenv(mongo_uri))
        db = client["ww1-france"]
        coll = db["events"]
        coll.insert_many(events)
        # prevent ADK from making a follow‑up LLM call (and serializing internal types)
        return "Events stored successfully."
    except Exception as e:
        return f"Error storing events: {e}"


root_agent = LlmAgent(
    name="StoreEventsAgent",
    model="gemini-2.0-flash",
    instruction="""You are given a variable `{events?}` containing a list of event dictionaries.

Call the tool `store_events_in_db` to insert `{events?}` into the database.
""",
    description="Store the given list of events in MongoDB",
    tools=[store_events_in_db],
    output_key="store_event_agent_output",
)

# mongo.Colleciton.insert_many() -> InsertManyResult:
# """Insert an iterable of documents.

# >>> result = db.test.insert_many([{'x': i} for i in range(2)])
# >>> result.inserted_ids
# [ObjectId('54f113fffba522406c9cc20e'), ObjectId('54f113fffba522406c9cc20f')]