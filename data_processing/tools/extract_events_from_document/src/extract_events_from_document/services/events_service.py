from tinydb import TinyDB
from tinydb.storages import JSONStorage
from common import MongoClientInstance
from bson import ObjectId
from extract_events_from_document.utils.str_date_to_datetime import strDateToDatetime

all_events = []


def preareEventsForStorage(regiment_id: ObjectId, events: list[dict]):
    return [
        {
            **event,
            "regiment_id": regiment_id,
            "start_at": strDateToDatetime(event["start_at"])
            if event["start_at"] is not None
            else None,
            "end_at": strDateToDatetime(event["end_at"])
            if event["end_at"] is not None
            else None,
        }
        for event in events
    ]


def storeEventsIbDb(events: list[dict]):
    # global all_events
    # if events:
    #     all_events += events
    client = MongoClientInstance()
    collection = client.get_database("french").get_collection("events")
    # events_without_id = [dict(events, _id=None)]
    collection.insert_many(events)
    # # events_storage_path = tool_context.state.get("events_db_path", "events.json")
    # # db = TinyDB(
    # #     events_storage_path,
    # #     storage=lambda path: JSONStorage(path, encoding="utf-8"),
    # # )
    # # db.insert_multiple(events)


def getEventsInDbFromPages(document_name: str, selected_pages: list[int]):
    # global all_events
    # return [
    #     event for event in all_events if event["document_source_page"] in selected_pages
    # ]
    client = MongoClientInstance()
    collection = client.get_database("french").get_collection("events")
    return collection.find(
        {
            "document_source": document_name,
            "document_source_page": {"$in": selected_pages},
        }
    ).to_list()


def deleteEventsInDb(events: list[dict]):
    # global all_events
    # all_events = [ev for ev in all_events if ev not in events]
    events_ids = [event["_id"] for event in events]
    client = MongoClientInstance()
    collection = client.get_database("french").get_collection("events")
    collection.delete_many({"_id": {"$in": events_ids}})


def printEvents(events: list[dict]):
    for i, event in enumerate(events, start=1):
        print(f"Événement {i}:")
        for key, value in event.items():
            if key in ["document_source_page", "title", "start_date"]:
                print(f"  {key}: {value}")
        print()  # ligne vide entre chaque événement
