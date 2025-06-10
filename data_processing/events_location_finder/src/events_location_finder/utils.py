import os
from google.genai.types import (
    GenerateContentResponse,
)

from common import (
    FileReader,
    get_document_page,
)


def display_thought(model_response: GenerateContentResponse):
    for part in model_response.candidates[0].content.parts:
        if not part.text:
            continue
        if part.thought:
            print("Thought summary:")
            print(part.text)
            print()


def get_instruction(event_kind: str):
    current_dir = os.path.dirname(__file__)
    filename = (
        "find_military_event_location_instruction.txt"
        if event_kind == "Événement militaire"
        else "find_troup_mouvement_location_instruction.txt"
    )

    instruction_path = os.path.join(current_dir, "prompts", filename)
    return FileReader().readFile(instruction_path)


def get_document_page_from_event(
    local_doc_folder_path: str, document_name: str, page: int
):
    document_path = os.path.join(local_doc_folder_path, document_name)
    return get_document_page(file_path=document_path, total_pages=99999, start_at=page)
