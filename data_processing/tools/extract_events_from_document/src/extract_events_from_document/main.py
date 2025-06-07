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
    return getRegimentIdByName(title)


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
        sys.exit("Erreur : Le document ne contient pas de pages")

    # if regiment history is null or ou arument => creation de l'history du regiment
    regiment_id = getRegimentIdFromFile(args.md_input_file)
    print(f"id du regiment: {regiment_id}")
    if regiment_id is None:
        sys.exit("""Regiment not found in database.
                 The 'title' in the database must respect the following pattern:
                 "[regiment_number]ème régiment d'infanterie"
                 """)

    createRegimentIdentityCardIfNotExist(regiment_id, document_content)
    extractEvents(
        file_path=args.md_input_file,
        regiment_id=regiment_id,
        total_pages=total_doc_pages,
        start_page=int(args.start_page),
    )
