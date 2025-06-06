import os
from google import genai
from google.genai import types
from extract_events_from_document.config import ADVANCED_MODEL
from dotenv import load_dotenv
from extract_events_from_document.prompts.create_regiment_description_instruction import create_regiment_description_instruction

all_events = []

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

client = genai.Client(api_key=GEMINI_API_KEY)

def generate_regiment_description(document_content):
    response = client.models.generate_content(
        model=ADVANCED_MODEL,
        contents=document_content,
        config=types.GenerateContentConfig(
            system_instruction=create_regiment_description_instruction,
            response_mime_type="application/json",
        ),
    )
    return response.text or ""  # .parsed si schéma

    
def getRegimentIdByName(regiment_name):
    return