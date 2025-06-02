from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.tools import ToolContext, agent_tool
from config import ADVANCED_MODEL
from multi_tool_agent.utils.calculate_model_call_size import calculate_req_size


remove_duplicate_events_agent = LlmAgent(
    name="RemoveDuplicateEventAgent",
    model=ADVANCED_MODEL,
    instruction="""

1 - Déterminer la page cible : la page cible est la première page de l'intervalle`{page_interval}`.
2 - Récupère les événements de `{extracted_events}` ayant pour source cette page.
3 - **Si aucun événements n'est lié à cette page, laisse la main au tool suivant.**

**Sinon Fusion des événements:**
4 - Retire c'est événements de la liste `{extracted_events}`.
5 - Compare c'est événements entre eux (mêmes attributs essentiels : titre, date, lieu, etc.) afin de trouver des doublons s'il y en a.
    - Si aucun doublon n'est trouvé, réintégre c'est éléments à `{extracted_events}` et **laisse la main au tool suivant.**
    
    - Si des doublons sont trouvés, fusionne les en un seul événements enrichissant les données (par exemple en combinant les descriptions ou en remplissant les champs manquants) si possible.
    - Ajoute cette nouvelle liste d'éléments fusionnés à `{extracted_events}`.
    - Laisse la main au tool suivant.
""",
    description="Fusionne les événements similaires de deux passages consécutifs",
    before_model_callback=calculate_req_size
)
