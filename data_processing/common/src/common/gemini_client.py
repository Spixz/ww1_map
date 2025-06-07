import os
from dotenv import load_dotenv
from google import genai

load_dotenv()

_client: genai.Client = None


class GeminiModels:
    advanded_model = "gemini-2.5-flash-preview-05-20"
    less_advanded_model = "gemini-2.0-flash"


def GeminiClientInstance() -> genai.Client:
    global _client
    if _client is None:
        _client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
    return _client
