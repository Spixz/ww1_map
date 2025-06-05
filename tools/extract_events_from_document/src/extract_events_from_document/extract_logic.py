import re
from google import genai
from google.genai import types
from config import GEMINI_API_KEY, LESS_ADVANDED_MODEL
from utils import FileReader  # vient de tools/utils/src/utils/__init__.py

from get_document_page import get_document_page

client = genai.Client(api_key=GEMINI_API_KEY)


class Interval:
    def __init__(self, start_at, end_at):
        self.start_at = start_at
        self.end_at = end_at

    start_at: int
    end_at: int
    
    def __str__(self):
        return f"[{self.start_at}-{self.end_at}]"


def geminiImageToMarkdown(image_path: str):
    prompt = FileReader.readFile("prompts/page_to_text.txt")
    file = client.files.upload(file=image_path)

    response = client.models.generate_content(
        model=LESS_ADVANDED_MODEL,
        contents=[file],
        config=types.GenerateContentConfig(
            system_instruction=prompt,
            response_mime_type='application/json',
        ),
    )
    text_response = response.text or ""
    return re.sub(r"```(?:markdown)?", "", text_response)


def extract_events(filepath: str, total_pages: int) -> None:
    # extracted_pages = 0
    # pages_per_interval = 1
    # start_at = 1
    # while extracted_pages < total_pages:
    #     interval_a = Interval(start_at=start_at, end_at=start_at + pages_per_interval)
    #     interval_b = Interval(
    #         start_at=interval_a.end_at, end_at=interval_a.end_at + pages_per_interval
    #     )
    #     pages_a = get_document_page(
    #         file_path=filepath, start_at=interval_a.start_at, end_at=interval_a.end_at
    #     )
    #     pages_b = get_document_page(
    #         file_path=filepath, start_at=interval_b.start_at, end_at=interval_b.end_at
    #     )
    #     print(f"intervalle a : {interval_a}")
    #     print(f"intervalle b : {interval_b}")
    #     extracted_pages = interval_b.end_at
    #     start_at = interval_b.end_at

    pages_per_interval = 1
    start_at = 1
    events = []
    all_events = []
    while start_at < total_pages:
        interval_a = Interval(start_at=start_at, end_at=start_at + pages_per_interval)
        if (events):
            page_content : str | None = get_document_page(filepath, total_pages, interval_a.start_at, interval_a.end_at)
            extracted_events = extractTool(page_content) # ! peut etre vide []
            # page a filter = interval_a.start_at
            # filtrage
            all_events += extracted_events
            events = []
        else:
            page_content : str | None = get_document_page(filepath, total_pages, interval_a.start_at, interval_a.end_at)
            events = extractTool(page_content=page_content)
            if interval_a.end_at >= total_pages: #pck on rentrera plus dans le while
                all_events += events 
        start_at = interval_a.end_at
        
def extractTool(page_content: str | None) -> list[dict]:
    if page_content is None:
        return []
    #call api