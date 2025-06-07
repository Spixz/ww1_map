import argparse
import re
import sys
from bson import ObjectId
from dotenv import load_dotenv
from pathlib import Path

from common import FileReader  # vient de tools/utils/src/utils/__init__.py
from extract_events_from_document.extract_logic import extractEvents
from extract_events_from_document.services.regiments_service import (
    getRegimentIdByName,
    createRegimentIdentityCardIfNotExist,
)


def getLastPageNumber(text: str):
    matches = re.findall(r"<!-- page: (\d+) -->", text)
    return int(matches[-1]) if matches else 0


def getRegimentIdFromFile(filepath: str) -> ObjectId | None:
    filename = Path(filepath).stem
    title = filename.replace("Historique du ", "")
    regimentId = getRegimentIdByName(title)
    if regimentId is None:
        print(
            f"Regiment with the title '{title}' not found in database. Create it before."
        )
    return regimentId


def main():
    parser = argparse.ArgumentParser(
        prog="EventsExtractor",
        description="Extract all events from a markdown document and store them inside a database",
    )
    parser.add_argument(
        "md_input_file", help="Markdown file containing the events to extracts"
    )
    parser.add_argument(
        "-db",
        "--events-db-path",
        help="Fichier dans lequelle sont stockés les events au format json.",
        default="events.json",
    )
    parser.add_argument(
        "-start",
        "--start-page",
        help="Page par laquelle débuterra l'extraction des évémements",
        default=1,
    )
    parser.add_argument("-v", "--verbose", action="store_true", default=False)
    args = parser.parse_args()

    document_content = FileReader().readFile(args.md_input_file)
    total_doc_pages = getLastPageNumber(document_content)
    if total_doc_pages == 0:
        return sys.exit("Erreur : Le document ne contient pas de pages")

    # if regiment history is null or ou arument => creation de l'history du regiment
    regimentId = getRegimentIdFromFile(args.md_input_file)
    print(f"id du regiment: {regimentId}")
    if regimentId is None:
        return

    createRegimentIdentityCardIfNotExist(regimentId)

    # extractEvents(args.md_input_file, total_doc_pages, start_page=int(args.start_page))
