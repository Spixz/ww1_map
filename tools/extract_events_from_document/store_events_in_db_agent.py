from typing import Any, Optional
from google.adk.agents import LlmAgent
from google.adk.agents.callback_context import CallbackContext
from google.genai.types import Content

# from google.adk.agents.llm_agent import AfterToolCallback
from multi_tool_agent.events_extractor_manager_agent.tools.store_event_in_db import (
    store_events_in_db,
)
from tools.extract_events_from_document.src.extract_events_from_document.config import ADVANCED_MODEL
from multi_tool_agent.utils.calculate_model_call_size import calculate_req_size


def _after_agent_callback(callback_context: CallbackContext) -> Optional[Content]:
    callback_context.state["extracted_events"] = []
    callback_context.state["remove_doublon_output"] = []


store_events_in_db_agent = LlmAgent(
    name="StoreEventsInDbAgent",
    model=ADVANCED_MODEL,
    instruction="""Stock en base de données une liste d'événements.
    
    **Règles strictes** :
    - **Si `{remove_doublon_output?}` est vide, passe directement la main à l'agent suivant.**
    
    1 - Utilise l'outil `store_events_in_db` pour stocker en base de donnée les événements issue de la liste `{remove_doublon_output?}`.
        - Si l'ajout échoue utilise l'outil `exit_loop`.
    2 - Passe la main à l'agent suivant.
    
    Returns:
        "Succès du stockages des événements en base de donnée".
""",
    description="Stock en base de données les événements contenu dans `{remove_doublon_output?}`",
    tools=[store_events_in_db],
    output_key="store_events_in_db_output",
    before_model_callback=calculate_req_size,
    after_agent_callback=_after_agent_callback,
)
