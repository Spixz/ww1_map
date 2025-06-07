import os
from pathlib import Path
from google.genai import types
from common import FileReader, GeminiClientInstance, GeminiModels
from json import loads
from extract_events_from_document.get_document_page import get_document_page
from extract_events_from_document.services.events_service import (
    all_events,
    storeEvents,
    getEventsFromPage,
    deleteEvents,
    printEvents,
)
from dotenv import load_dotenv

load_dotenv()


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


def extractEventsFromPage(file_path: str, page_content: str | None) -> list[dict]:
    if page_content is None:
        return []
    current_dir = os.path.dirname(__file__)
    instruction_path = os.path.join(
        current_dir, "prompts", "extract_events_instruction.txt"
    )
    instruction = FileReader().readFile(instruction_path)

    prompt = f"""
        Nom du document : {Path(file_path).name}
        
        Contenu du document:
        {page_content}
    """

    response = GeminiClientInstance().models.generate_content(
        model=GeminiModels.advanded_model,
        contents=prompt,
        config=types.GenerateContentConfig(
            system_instruction=instruction,
            response_mime_type="application/json",
        ),
    )
    text_response = response.text or ""  # .parsed si schéma
    try:
        return loads(text_response)
    except Exception:
        return []
    # return re.sub(r"```(?:json)?", "", text_response)


def removeDoublon(events: list[dict], targeted_page: int) -> list[dict]:
    if len(events) == 0:
        return []

    current_dir = os.path.dirname(__file__)
    instruction_path = os.path.join(
        current_dir, "prompts", "remove_duplicate_events_instructions.txt"
    )
    instruction = FileReader().readFile(instruction_path)

    prompt = f"""
        page_cible = {targeted_page}
        all_events = {events}
    """

    response = GeminiClientInstance().models.generate_content(
        model=GeminiModels.advanded_model,
        contents=prompt,
        config=types.GenerateContentConfig(
            system_instruction=instruction,
            response_mime_type="application/json",
        ),
    )
    text_response = response.text or ""  # .parsed si schéma

    try:
        return loads(text_response)
    except Exception:
        return events


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
        ex_events = extractEventsFromPage(file_path, page_content)
        print("Événements trouvés:")
        printEvents(ex_events)

        old_events = getEventsFromPage([interval.start_at])
        print(f"ANCIENS EVENTS DE LA PAGE {interval.start_at} STOCKES EN DB")
        printEvents(old_events)
        deleteEvents(old_events)
        final = ex_events + old_events
        final = removeDoublon(final, interval.start_at)
        print(f"EVENEMENTS SANS DOUBLONS QUI SERONT STOCKE POUR {interval}")
        printEvents(final)
        storeEvents(final)
        print("ALL EVENTS")
        printEvents(all_events)
        print("\n\n\n")
        start_at = interval.end_at

    print("All Events Final !!!!!")
    printEvents(all_events)
