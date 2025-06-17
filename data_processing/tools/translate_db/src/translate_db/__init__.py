# translate_db.py
import argparse
import json
from dotenv import load_dotenv
from tqdm import tqdm
from typing import Optional, Type, Dict, Any, List

from google.genai import types
from pydantic import BaseModel

from common import MongoClientInstance, GeminiClientInstance, GeminiModels
from translate_db.models import (
    RegimentForTranslation,
    TroopMovementForTranslation,
    MilitaryEventForTranslation,
    PoliticalEventForTranslation,
)

load_dotenv()

# Map qui associe le nom de la collection à son modèle de traduction
COLLECTION_TO_TRANSLATION_MODEL_MAP = {"regiments": RegimentForTranslation}

# Map qui associe le type d'événement à son modèle de traduction
EVENT_TYPE_TO_TRANSLATION_MODEL_MAP = {
    "Mouvement de troupes": TroopMovementForTranslation,
    "Événement militaire": MilitaryEventForTranslation,
    "Événement politique": PoliticalEventForTranslation,
}


def translate_content(
    source_data: Dict[str, Any],
    pydantic_model: Type[BaseModel],
    target_language: str,
) -> Dict[str, Any]:
    """
    Traduit un dictionnaire de contenu en utilisant Gemini et un schéma Pydantic.
    """

    system_instruction = f"""
    You are an expert translator specializing in the WW1.
    Translate the provided JSON object from French to {target_language}.
    - Adhere strictly to the provided JSON schema for your response.
    - Keep the original meaning and historical context.
    - Do not translate proper nouns like names of people or specific, unique historical place names.
    - Field names in the JSON must remain in English as specified in the schema.
    """

    prompt = json.dumps(source_data, ensure_ascii=False, indent=2)

    try:
        response = GeminiClientInstance().models.generate_content(
            model=GeminiModels.less_advanded_model,
            contents=prompt,
            config=types.GenerateContentConfig(
                system_instruction=system_instruction,
                response_mime_type="application/json",
                response_schema=pydantic_model.model_json_schema(),
                # thinking_config=types.ThinkingConfig(thinking_budget=0),
            ),
        )
        return json.loads(response.text)
    except Exception as e:
        print(f"\nAn error occurred during translation: {e}")
        print(f"Problematic source data: {source_data}")
        return {}


def translate_collection(
    source_db_name: str,
    target_db_name: str,
    collection_name: str,
    target_language: str,
    translation_model_map: Dict[str, Any],
    discriminator_field: Optional[str] = None,
    start_at_id: Optional[str] = None,
):
    """
    Fonction générique pour traduire les documents d'une collection source vers une collection cible.
    Elle préserve la structure complète et les ID des documents originaux.
    """
    mongo_client = MongoClientInstance()
    source_collection = mongo_client.get_database(source_db_name).get_collection(
        collection_name
    )
    target_collection = mongo_client.get_database(target_db_name).get_collection(
        collection_name
    )

    if not start_at_id:
        target_collection.delete_many({})
        print(f"Cleared target collection: {target_db_name}.{collection_name}")
        documents_to_process = list(source_collection.find())
    else:
        print(
            f"\nResuming translation for collection '{collection_name}' starting at ID: {start_at_id}"
        )
        all_documents = list(source_collection.find())
        try:
            start_index = [str(doc["_id"]) for doc in all_documents].index(start_at_id)
            documents_to_process = all_documents[start_index:]
            print(
                f"Found {len(documents_to_process)} documents to process starting from the specified ID."
            )
        except ValueError:
            print(
                f"FATAL: Start ID '{start_at_id}' not found in collection '{collection_name}'."
            )
            raise

    # La liste temporaire n'est plus nécessaire.
    # translated_docs_to_insert = []

    print(
        f"\nTranslating and inserting documents for collection '{collection_name}'..."
    )
    for doc in tqdm(documents_to_process, desc=f"Processing {collection_name}"):
        pydantic_model_for_translation: Type[BaseModel] | None
        final_doc = None

        if discriminator_field:
            doc_type = doc.get(discriminator_field)
            pydantic_model_for_translation = translation_model_map.get(doc_type)
        else:
            pydantic_model_for_translation = translation_model_map

        # --- Étape 1: Préparer les données à traduire (si nécessaire) ---
        if not pydantic_model_for_translation:
            print(
                f"Warning: No translation model for type '{doc.get(discriminator_field)}'. Copying doc {doc['_id']} as is."
            )
            final_doc = doc.copy()
        else:
            data_to_translate = {}
            for field_name in pydantic_model_for_translation.model_fields.keys():
                if field_name in doc and doc[field_name] is not None:
                    data_to_translate[field_name] = doc[field_name]

            if not data_to_translate:
                # Aucun champ à traduire, on copie l'original
                final_doc = doc.copy()
            else:
                # --- Étape 2: Traduire ---
                translated_fields = translate_content(
                    data_to_translate, pydantic_model_for_translation, target_language
                )

                if not translated_fields:
                    error_message = f"""
                    \n----------------------------------------------------------------
                    FATAL: Translation failed for document in collection '{collection_name}'.
                    
                    Document ID: {doc["_id"]}
                    
                    To fix this, correct the source data or the prompt, then resume the script from this point using:
                    
                    python your_script_name.py {target_db_name} {target_language} --collection {collection_name} --start-at-id {doc["_id"]}
                    
                    Problematic data sent to API:
                    {json.dumps(data_to_translate, indent=2, ensure_ascii=False)}
                    ----------------------------------------------------------------
                    """
                    raise ValueError(error_message)

                # --- Étape 3: Préparer le document final ---
                final_doc = doc.copy()
                final_doc.update(translated_fields)

        # --- Étape 4: Écrire IMMÉDIATEMENT le document dans la DB cible ---
        if final_doc:
            target_collection.replace_one(
                {"_id": final_doc["_id"]},  # Filtre de recherche
                final_doc,  # Document de remplacement
                upsert=True,  # Créer le document s'il n'existe pas
            )

    # L'insertion en masse à la fin est maintenant supprimée.
    print(f"\nProcessing complete for collection '{collection_name}'.")


def main():
    parser = argparse.ArgumentParser(
        prog="TranslateDB",
        description="Translate collections from the 'french' database to a new database in a target language. Can resume from a specific document.",
        formatter_class=argparse.RawTextHelpFormatter,  # Pour un meilleur affichage de l'aide
    )
    parser.add_argument(
        "new_database_name",
        help="The name of the new database to store the translations.",
    )
    parser.add_argument(
        "language", help="The target language for the translation (e.g., 'English')."
    )
    parser.add_argument(
        "--collection",
        help="Specify a single collection to translate (e.g., 'regiments' or 'events').\nRequired if --start-at-id is used.",
        default=None,
    )
    parser.add_argument(
        "--start-at-id",
        help="The MongoDB _id of the document to start the translation from.\nRequires --collection to be set.",
        default=None,
    )

    args = parser.parse_args()

    # Validation des arguments pour la reprise
    if args.start_at_id and not args.collection:
        parser.error("--collection is required when using --start-at-id.")

    if args.collection and args.collection not in ["regiments", "events"]:
        parser.error(
            f"Invalid collection name '{args.collection}'. Must be 'regiments' or 'events'."
        )

    source_db = "french"
    target_db = args.new_database_name
    language = args.language

    print(f"Starting translation from '{source_db}' to '{target_db}' in {language}.")

    # Logique pour exécuter une traduction complète ou une reprise
    if args.collection:
        # Mode reprise ou traduction d'une seule collection
        print(f"Running in single-collection mode for: '{args.collection}'")
        if args.collection == "regiments":
            translate_collection(
                source_db_name=source_db,
                target_db_name=target_db,
                collection_name="regiments",
                target_language=language,
                translation_model_map=COLLECTION_TO_TRANSLATION_MODEL_MAP["regiments"],
                discriminator_field=None,
                start_at_id=args.start_at_id,
            )
        elif args.collection == "events":
            translate_collection(
                source_db_name=source_db,
                target_db_name=target_db,
                collection_name="events",
                target_language=language,
                translation_model_map=EVENT_TYPE_TO_TRANSLATION_MODEL_MAP,
                discriminator_field="event_kind",
                start_at_id=args.start_at_id,
            )
    else:
        # Mode par défaut : traduire toutes les collections depuis le début
        print("Running in full translation mode.")
        # Traduire la collection des régiments
        translate_collection(
            source_db_name=source_db,
            target_db_name=target_db,
            collection_name="regiments",
            target_language=language,
            translation_model_map=COLLECTION_TO_TRANSLATION_MODEL_MAP["regiments"],
            discriminator_field=None,
        )

        # Traduire la collection des événements
        translate_collection(
            source_db_name=source_db,
            target_db_name=target_db,
            collection_name="events",
            target_language=language,
            translation_model_map=EVENT_TYPE_TO_TRANSLATION_MODEL_MAP,
            discriminator_field="event_kind",
        )

    print("\nTranslation process finished successfully!")


if __name__ == "__main__":
    main()
