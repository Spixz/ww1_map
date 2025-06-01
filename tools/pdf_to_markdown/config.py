import os
from dotenv import load_dotenv

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

if GEMINI_API_KEY is None:
    raise Exception("Add required env variables : GEMINI_API_KEY")

ADVANCED_MODEL = "gemini-2.5-flash-preview-05-20"
LESS_ADVANDED_MODEL = "gemoni-2.0-flash"