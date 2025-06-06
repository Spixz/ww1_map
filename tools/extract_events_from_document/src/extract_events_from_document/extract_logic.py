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
from utils import FileReader  # vient de tools/utils/src/utils/__init__.py
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

    def __str__(self):
        return f"[{self.start_at}-{self.end_at}]"


def storeEventsInDb(events):
    global all_events
    if events:
        all_events += events


def printEvents(events):
    for i, event in enumerate(events, start=1):
        print(f"Événement {i}:")
        for key, value in event.items():
            print(f"  {key}: {value}")
        print()  # ligne vide entre chaque événement


def extractEvents(file_path: str, total_pages: int) -> None:
    pages_per_interval = 1
    start_at = 1
    events = []
    while start_at < total_pages:
        interval = Interval(start_at=start_at, end_at=start_at + pages_per_interval)
        print(f"intevalle {interval}")
        if events:
            print("2nd partie")
            page_content = get_document_page(
                file_path, total_pages, interval.start_at, interval.end_at
            )
            print(page_content)
            ex_events = extractTool(file_path, page_content)
            events += ex_events

            print("Événements trouvés:")
            printEvents(ex_events)
            events_without_doublon = removeDoublonTool(
                events, targeted_page=interval.start_at
            )
            if len(events) != len(events_without_doublon):
                print("des doublons ont été trouvés et supprimé !!!!!!")
                print("La version sans doublon :")
                printEvents(events_without_doublon)
            else:
                print("PAs de doublons trouvés !!!!")
            storeEventsInDb(events_without_doublon)
            events = []
        else:
            print("1er partie")
            page_content = get_document_page(
                file_path, total_pages, interval.start_at, interval.end_at
            )
            print(page_content)
            ex_events = extractTool(file_path, page_content)
            events += ex_events

            print("Événements trouvés:")
            printEvents(ex_events)

            if interval.end_at >= total_pages:  # pck on rentrera plus dans le while
                storeEventsInDb(events)

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
