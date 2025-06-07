import os
from typing import Any
from google.genai import types
from common import FileReader, MongoClientInstance, GeminiClientInstance, GeminiModels
from bson import ObjectId


def generateRegimentDescription(document_content):
    current_dir = os.path.dirname(__file__)
    prompt_path = os.path.join(
        current_dir, "prompts", "create_regiment_description_instruction.txt"
    )
    instruction = FileReader.readFile(prompt_path)

    response = GeminiClientInstance().models.generate_content(
        model=GeminiModels.advanded_model,
        contents=document_content,
        config=types.GenerateContentConfig(
            system_instruction=instruction,
            response_mime_type="application/json",
            thinking_config=types.ThinkingConfig(thinking_budget=0),
        ),
    )
    return response.text or ""  # .parsed si schéma


def getRegimentIdByName(regiment_name) -> ObjectId | None:
    client = MongoClientInstance()
    database = client.get_database("french")
    regiments = database.get_collection("regiments")
    regiment_data: Any | None = regiments.find_one({"title": regiment_name})

    return None if regiment_data is None else regiment_data["_id"]

def createRegimentIdentityCardIfNotExist(regiment_id: ObjectId):
    return