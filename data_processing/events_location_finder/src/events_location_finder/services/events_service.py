from common import MongoClientInstance
from bson import ObjectId


def storeEventsIbDb(events: list[dict]):
    client = MongoClientInstance()
    collection = client.get_database("french").get_collection("events")
    collection.insert_many(events)


def getEventsInDbFromPages(document_name: str, selected_pages: list[int]):
    client = MongoClientInstance()
    collection = client.get_database("french").get_collection("events")
    return collection.find(
        {
            "document_source": document_name,
            "document_source_page": {"$in": selected_pages},
        }
    ).to_list()


def deleteEventsInDb(events: list[dict]):
    events_ids = [event["_id"] for event in events]
    client = MongoClientInstance()
    collection = client.get_database("french").get_collection("events")
    collection.delete_many({"_id": {"$in": events_ids}})


def updateEventCoordinates(event_id: ObjectId, coordinates: dict | list[dict]):
    client = MongoClientInstance()
    collection = client.get_database("french").get_collection("events")
    filter = {"_id": event_id}
    collection.update_one(filter, {"$set": {"coordinates": coordinates}})


def printEvent(event: dict, property_names: list[str] = []):
    for key, value in event.items():
        if property_names:
            if key in property_names:
                print(f"  {key}: {value}")
        else:
            print(f"  {key}: {value}")
    print()


def printEvents(events: list[dict], property_names: list[str] = []):
    for i, event in enumerate(events, start=1):
        print(f"Événement {i}:")
        printEvent(event, property_names)
