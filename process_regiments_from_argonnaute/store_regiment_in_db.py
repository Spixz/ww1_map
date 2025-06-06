import os
import json
from pymongo import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv

load_dotenv()

_client = None


def get_mongo_client():
    global _client
    if _client is None:
        mongo_uri = os.getenv("MONGO_URI") or "mongodb://localhost:27017"
        _client = MongoClient(mongo_uri, server_api=ServerApi("1"))
    return _client


def clean_title(title: str) -> str:
    return title.replace("Historique du ", "").replace("Historique de la ", "").strip()


def store_regiments_in_db(regiments: list[dict]):
    client = get_mongo_client()
    database = client["french"]
    collection = database["regiments"]

    for r in regiments:
        r["title"] = clean_title(r["title"])

    result = collection.insert_many(regiments)
    print(f"{len(result.inserted_ids)} doc inserted.")

    collection.create_index("title")


def load_json_file(path: str) -> list[dict]:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


if __name__ == "__main__":
    filepath = "regiments_complet.json"
    data = load_json_file(filepath)
    store_regiments_in_db(data)
