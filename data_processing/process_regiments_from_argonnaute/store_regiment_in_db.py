import json

from common import MongoClientInstance


def clean_title(title: str) -> str:
    return title.replace("Historique du ", "").replace("Historique de la ", "").strip()


def store_regiments_in_db(regiments: list[dict]):
    client = MongoClientInstance()
    database = client.get_database("french")
    collection = database.get_collection("regiments")

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
