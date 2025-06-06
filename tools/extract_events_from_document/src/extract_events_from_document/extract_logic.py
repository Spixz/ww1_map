import re
import os
from google import genai
from google.genai import types
from extract_events_from_document.config import ADVANCED_MODEL
from extract_events_from_document.prompts.extract_events_instruction import (
    extract_events_instruction,
)
from extract_events_from_document.prompts.remove_duplicate_events_instructions import (
    remove_duplicate_events_instructions,
)
from common import FileReader  # vient de tools/utils/src/utils/__init__.py
from json import loads
from extract_events_from_document.get_document_page import get_document_page

from dotenv import load_dotenv

all_events = []

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

client = genai.Client(api_key=GEMINI_API_KEY)


class Interval:
    def __init__(self, start_at, end_at):
        self.start_at = start_at
        self.end_at = end_at

    start_at: int
    end_at: int

    @property
    def containedNumber(self):
        return list(range(self.start_at, self.end_at + 1))

    def __str__(self):
        return f"[{self.start_at}-{self.end_at}]"


def storeEventsInDb(events: list[dict]):
    global all_events
    if events:
        all_events += events


def getEventsFromPageInDb(selected_pages: list[int]):
    global all_events
    return [
        event for event in all_events if event["document_source_page"] in selected_pages
    ]


def deleteEventsFromDb(events):
    global all_events
    all_events = [ev for ev in all_events if ev not in events]


def printEvents(events):
    for i, event in enumerate(events, start=1):
        print(f"Événement {i}:")
        for key, value in event.items():
            # if key in ["document_source_page", "title", "start_date"]:
            print(f"  {key}: {value}")
        print()  # ligne vide entre chaque événement


def extractEvents(file_path: str, total_pages: int, start_page: int = 1) -> None:
    pages_per_interval = 1
    start_at = start_page
    while start_at < total_pages:
        interval = Interval(start_at=start_at, end_at=start_at + pages_per_interval)
        page_content = get_document_page(
            file_path, total_pages, interval.start_at, interval.end_at
        )
        print(f"========INTERVALLE {interval}=========")
        print(page_content)
        ex_events = extractTool(file_path, page_content)
        print("Événements trouvés:")
        printEvents(ex_events)

        old_events = getEventsFromPageInDb([interval.start_at])
        print(f"ANCIENS EVENTS DE LA PAGE {interval.start_at} STOCKES EN DB")
        printEvents(old_events)
        deleteEventsFromDb(old_events)
        final = ex_events + old_events
        final = removeDoublonTool(final, interval.start_at)
        print(f"EVENEMENTS SANS DOUBLONS QUI SERONT STOCKE POUR {interval}")
        printEvents(final)
        storeEventsInDb(final)
        print("ALL EVENTS")
        printEvents(all_events)
        print("\n\n\n")
        start_at = interval.end_at

    print("All Events Final !!!!!")
    printEvents(all_events)


# l'aternance des pages se fait bien.


def extractTool(file_path: str, page_content: str | None) -> list[dict]:
    if page_content is None:
        return []
    prompt = f"""
        Nom du document : {os.path.basename(file_path)}
        
        Contenu du document:
        {page_content}
    """

    response = client.models.generate_content(
        model=ADVANCED_MODEL,
        contents=prompt,
        config=types.GenerateContentConfig(
            system_instruction=extract_events_instruction,
            response_mime_type="application/json",
        ),
    )
    text_response = response.text or ""  # .parsed si schéma
    try:
        return loads(text_response)
    except Exception:
        return []
    # return re.sub(r"```(?:json)?", "", text_response)


def removeDoublonTool(events: list[dict], targeted_page: int) -> list[dict]:
    if len(events) == 0:
        return []

    prompt = f"""
        page_cible = {targeted_page}
        all_events = {events}
    """

    response = client.models.generate_content(
        model=ADVANCED_MODEL,
        contents=prompt,
        config=types.GenerateContentConfig(
            system_instruction=remove_duplicate_events_instructions,
            response_mime_type="application/json",
        ),
    )
    text_response = response.text or ""  # .parsed si schéma
    try:
        return loads(text_response)
    except Exception:
        return events
