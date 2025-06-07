from tinydb import TinyDB
from tinydb.storages import JSONStorage
from common import MongoClientInstance


all_events = []

def storeEvents(events: list[dict]):
    global all_events
    if events:
        all_events += events
    # client = MongoClientInstance()
    # database = client.get_database("french")
    # collection = database.get_collection("regiments")
    # collection.insert_many(events)
    # # events_storage_path = tool_context.state.get("events_db_path", "events.json")
    # # db = TinyDB(
    # #     events_storage_path,
    # #     storage=lambda path: JSONStorage(path, encoding="utf-8"),
    # # )
    # # db.insert_multiple(events)


def getEventsFromPage(selected_pages: list[int]):
    global all_events
    return [
        event for event in all_events if event["document_source_page"] in selected_pages
    ]


def deleteEvents(events: list[dict]):
    global all_events
    all_events = [ev for ev in all_events if ev not in events]


def printEvents(events: list[dict]):
    for i, event in enumerate(events, start=1):
        print(f"Événement {i}:")
        for key, value in event.items():
            # if key in ["document_source_page", "title", "start_date"]:
            print(f"  {key}: {value}")
        print()  # ligne vide entre chaque événement
