from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.tools import ToolContext, agent_tool, BaseTool
# from google.adk.agents.llm_agent import AfterToolCallback
from multi_tool_agent.events_extractor_manager_agent.tools.store_event_in_db import (
    store_events_in_db,
)
from config import ADVANCED_MODEL
from multi_tool_agent.utils.calculate_model_call_size import calculate_req_size


store_events_in_db_agent = LlmAgent(
    name="StoreEventsInDbAgent",
    model=ADVANCED_MODEL,
    instruction="""Stock en base de données une liste d'événements.
    
    **Règles strictes** :
    - **Si `{extracted_events?}` est vide, passe directement la main à l'agent suivant.**
    
    1 - Utilise l'outil `store_events_in_db` pour stocker en base de donnée les événements issue de la liste `{extracted_events?}`.
        - Si l'ajout échoue utilise l'outil `exit_loop`.
    2 - Après l'insertion, vide `{extracted_events?}` puis passe la main à l'agent suivant.
    
    Returns:
        "Succès du stockages des événements en base de donnée".
""",
    description="Stock en base de données les événements contenu dans `{extracted_events?}`",
    tools=[store_events_in_db],
    output_key="store_events_in_db_output",
    before_model_callback=calculate_req_size
)
