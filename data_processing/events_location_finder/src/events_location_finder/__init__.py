from joblib import Parallel, delayed
import re
import argparse

from tenacity import retry, stop_after_attempt
from google.genai.types import (
    GenerateContentConfig,
    ThinkingConfig,
)
from json import loads

from common import (
    MongoClientInstance,
    GeminiClientInstance,
    GeminiModels,
)
from events_location_finder.services.events_service import (
    printEvent,
    updateEventCoordinates,
)
from events_location_finder.tools import (
    web_search_tool,
    get_places_gps_coordinates,
)
from events_location_finder.utils import (
    get_instruction,
    get_document_page_from_event,
    display_thought,
)


@retry(stop=stop_after_attempt(3))
def get_event_coordinates(event: dict, page_content: str) -> list[dict] | dict | None:
    instruction = get_instruction(event["event_kind"])

    prompt = f"""
        Page de laquelle est issue l'événement:
        {page_content}
        
        Événement:
        {event}
    """

    response = GeminiClientInstance().models.generate_content(
        model=GeminiModels.advanded_model,
        contents=prompt,
        config=GenerateContentConfig(
            system_instruction=instruction,
            tools=[
                get_places_gps_coordinates,
                web_search_tool,
            ],
            thinking_config=ThinkingConfig(
                include_thoughts=True,
            ),
        ),
    )
    text_response = response.text or ""
    # display_thought(response)

    try:
        json_string = re.sub(r"```(?:json)?", "", text_response)
        return loads(json_string)
    except Exception:
        print("erreur durant la conversion des résultats en json")
        print(json_string)
        return None


def get_event_coordinates_and_update(event: dict, doc_folder_path: str):
    document_source = get_document_page_from_event(
        local_doc_folder_path=doc_folder_path,
        document_name=event["document_source"],
        page=event["document_source_page"],
    )
    # print(document_source)
    improved_location = get_event_coordinates(event, page_content=document_source)
    printEvent(event)
    print(improved_location)
    updateEventCoordinates(event["_id"], improved_location)


def events_iterator(doc_folder_path: str):
    client = MongoClientInstance()
    collection = client.get_database("french").get_collection("events")
    query_raw_location = {
        "$or": [
            {
                "event_kind": "Mouvement de troupes",
                "departure_point": {"$type": "string"},
                "arrival_point": {"$type": "string"},
                "coordinates": {"$exists": False},
            },
            {
                "event_kind": "Événement militaire",
                "location": {"$type": "string"},
                "coordinates": {"$exists": False},
            },
        ]
    }

    # no iteration on the cursor to avoir cursor timeout
    events = collection.find(query_raw_location).limit(4).to_list()
    while events:
        Parallel(n_jobs=4, backend="threading", verbose=1)(
            delayed(get_event_coordinates_and_update)(ev, doc_folder_path)
            for ev in events
        )
        events = collection.find(query_raw_location).limit(4).to_list()


def main():
    parser = argparse.ArgumentParser(
        description="For each event in the database, determine the precise GPS location and add it to the coordinate fields."
    )
    parser.add_argument(
        "doc_folder",
        type=str,
        help="Folder containing the documents used for the creation of events",
    )
    args = parser.parse_args()
    events_iterator(doc_folder_path=args.doc_folder)
