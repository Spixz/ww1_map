import argparse
import re
import sys
from dotenv import load_dotenv
from utils import FileReader  # vient de tools/utils/src/utils/__init__.py


def get_last_page_number(text: str):
    matches = re.findall(r"<!-- page: (\d+) -->", text)
    return int(matches[-1]) if matches else 0

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
    parser.add_argument("-v", "--verbose", action="store_true", default=False)
    args = parser.parse_args()

    document_content = FileReader().readFile(args.md_input_file)
    total_doc_pages = get_last_page_number(document_content)
    if total_doc_pages == 0:
        return sys.exit("Erreur : Le document ne contient pas de pages")
