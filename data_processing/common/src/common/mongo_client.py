import os
from pymongo import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv

load_dotenv()

_client: MongoClient = None

def MongoClientInstance() -> MongoClient:
    global _client
    if _client is None:
        mongo_uri = os.getenv("MONGO_URI") or "mongodb://localhost:27017"
        _client = MongoClient(mongo_uri, server_api=ServerApi("1"))
    return _client
