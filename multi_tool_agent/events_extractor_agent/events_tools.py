from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.tools import ToolContext, agent_tool
from pydantic import BaseModel, Field
import re

from config import GEMINI_2_FLASH, SOURCE_DOC, TOTAL_DOC_PAGES


#  ? ecrire le docstring: What the tool does. When to use it. What arguments it requires (city: str). What information it returns.
def get_capital_city(country: str) -> str:
    """Retrieves the current weather report for a specified city.

    Args:
        city (str): The name of the city (e.g., "New York", "London", "Tokyo").

    Returns:
        dict: A dictionary containing the weather information.
              Includes a 'status' key ('success' or 'error').
              If 'success', includes a 'report' key with weather details.
              If 'error', includes an 'error_message' key.
    """
    capitals = {"france": "Paris", "japan": "Tokyo", "canada": "Ottawa"}
    return capitals.get(
        country.lower(), f"Sorry, I don't know the capital of {country}."
    )


def extract_pages(content: str, pattern: str) -> str | None:
    match = re.search(pattern, content, re.DOTALL)
    return match.group(1) if match else None


def get_document_page(page_interval: str) -> str:
    """Récupère dans le document les pages comprises dans l'intervalle.

    Args:
        page_interval (str): L'intervalle comprenant les pages à récupérer (e.g., "1", "3-10", "12", "45-100").

    Returns:
        En cas de succès return  {"status": "success", "text": "le texte extrait des pages"}
        En cas d'erreur return  {"status": "error", "text": null}
    """
    try:
        page_indexs: list[int] = map(int, page_interval.split("-"))
        nb_index_given = len(page_indexs)

        if len(page_indexs) == 0:
            return '{"status":"error", "text": null}'
        # ! si veut recup la deniere page erreur car pas de limite
        start_at: int = page_indexs[0]
        end_at: int = start_at + 1 if nb_index_given == 1 else page_indexs[1]
        expression = rf"(<!-- page: {start_at} -->.*?)(?=<!-- page: {end_at} -->)"

        with open(SOURCE_DOC, "r", encoding="utf-8") as file:
            content = file.read()
            extracted_pages = extract_pages(content=content, pattern=expression)
        return f'{"status":"success", "text": {extracted_pages}}'
    except Exception as _:
        return '{"status":"error", "text": null}'


# CONSTANTS


# STATES INDEXES
STATE_LAST_EXTRACTED_PAGE_NUMBER = "last_extracted_page_number"


class CapitalOutput(BaseModel):
    capital: str = Field(description="The capital of the country.")


# TODO : Faire qu'il suive un schéma
event_extractor_agent_tool = LlmAgent(
    name="EventExtractorAgent",
    model="gemini-2.0-flash",
    instruction="""
    Tu es un historien chargé de créer une timeline des évènements
de la première guerre mondiale.

Tu dois créer un objet événement en fonction du type de l'événement:


Types:
start_date et end_date : "%Y-%m-%d %H:%M:%S"
localisation : Pays, ville, lieu
document_source: "titre_du_document, page"

si un champ quelque soit son nom est non applicable, set sa valeur à null

Les événements politiques : 
{
	"type": "Événement politique",
	"start_date", 
	"end_date", (si applicable)
	"description",
	"titre", (résumé de la description)
	"categorie",
	"document_source",
}

Les mouvement de troupes :
{
	"type": "Mouvement de troupes",
	"start_date",
	"end_date", (si applicable)
	"description",
	"title", (résumé de la description)
	"type de mouvement",
	"protagoniste",
	"position de départ",
	"arrivée",
	"document_source",
}

Les événements militaire:
{
	"type": "Événement militaire",
	"start_date",
	"end_date", (si applicable)
	"localisation",
	"type", (affrontement, fortification, ...)
	"commenditaire",
	"éxécutant",
	"ordre",
	"cible", (si applicable)
	"résultat", (si applicable)
	"description",
	"title": (résumé de la description),
	"document_source",
}

Tu retournera une liste d'événements.
""",
    description="Extraits les événements",
    output_key="extracted_events",
    tools=[get_capital_city],
)
