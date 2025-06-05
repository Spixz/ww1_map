import re
from google import genai
from google.genai import types
from config import GEMINI_API_KEY, LESS_ADVANDED_MODEL
from utils import FileReader  # vient de tools/utils/src/utils/__init__.py

from get_document_page import get_document_page

client = genai.Client(api_key=GEMINI_API_KEY)


def geminiImageToMarkdown(image_path: str):
    prompt = FileReader.readFile("prompts/page_to_text.txt")
    file = client.files.upload(file=image_path)

    response = client.models.generate_content(
        model=LESS_ADVANDED_MODEL,
        contents=[file],
        config=types.GenerateContentConfig(
            system_instruction=prompt,
        ),
    )
    text_response = response.text or ""
    return re.sub(r"```(?:markdown)?", "", text_response)

def extract_events(filepath: str, total_pages: int) -> None:
    # loop
    get_document_page(file_path=filepath, )