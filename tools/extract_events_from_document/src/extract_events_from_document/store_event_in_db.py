import os
from google.adk.tools import ToolContext, FunctionTool
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from tinydb import TinyDB
from tinydb.storages import JSONStorage

_client = None


def get_mongo_client():
    global _client
    if _client is None:
        mongo_uri = os.getenv("MONGO_URI") | "mongodb://localhost:27017"
        _client = MongoClient(mongo_uri, server_api=ServerApi("1"))
    return _client


def store_events_in_db(events: list[dict]):
    """Stock les événements en base de données.

    Args:
        events (List<dict>) : Les événements à stocker.
    """
    client = get_mongo_client()
    database = client["ww1-france"]
    collection = database["events"]
    collection.insert_many(events)
    # events_storage_path = tool_context.state.get("events_db_path", "events.json")
    # db = TinyDB(
    #     events_storage_path,
    #     storage=lambda path: JSONStorage(path, encoding="utf-8"),
    # )
    # db.insert_multiple(events)
