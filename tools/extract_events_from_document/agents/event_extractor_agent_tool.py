from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.tools import ToolContext, agent_tool

from tools.extract_events_from_document.src.extract_events_from_document.config import ADVANCED_MODEL
from multi_tool_agent.events_extractor_manager_agent.tools.get_document_page import (
    get_document_page,
)
from multi_tool_agent.events_extractor_manager_agent.tools.str_date_to_datetime import (
    str_date_to_datetime,
)
from multi_tool_agent.utils.calculate_model_call_size import calculate_req_size


event_extractor_agent_tool = LlmAgent(
    name="EventExtractorAgent",
    model=ADVANCED_MODEL,
    instruction="""

Tu es un historien expert chargé de construire une frise chronologique des événements liés à la Première Guerre mondiale à partir d’un document source.

Le texte du document est accessible grâce au tool `get_document_page`, qui prend deux paramètres :
- `{source_doc?}` : le nom du document,
- `{page_interval?}` : l’intervalle de pages à examiner.

**Ta mission** :
1. Récupère le texte via `get_document_page`({source_doc?}, {page_interval?}).
2. Analyse ce texte pour identifier des événements historiques pertinents répondants aux genres suivants :
	- Événement politique
	- Mouvement de troupes
	- Événement militaire
3. Pour chaque événement identifié, crée un objet structuré correspondant à l’un des genres d’événements définis ci-dessous.

⚠️ Règles importantes :
- Si un champ ne s'applique pas, définis-le explicitement à `null`.
- Les dates doivent être au format **"%Y-%m-%d %H:%M:%S"**.
- Le champ `document_source` doit contenir **"titre_du_document"**.
- Résume la description dans le champ `title`.
- Retourne une **liste d’événements** sous la forme `[{...}, {...}]`, ou une string **`aucun évènement trouvé`** si aucun événement n’est trouvé.


Les événements politiques : 
{
	"event_kind": "Événement politique",
	"start_date",
	"end_date", (si applicable)
	"description",
	"title",
	"document_source",
	"document_source_page" (int)
}

Les mouvements de troupes :
{
	"event_kind": "Mouvement de troupes",
	"start_date",
	"end_date", (si applicable)
	"description",
	"title",
	"movement_type",
	"executing_unit",
	"departure_point",
	"arrival_point",
	"document_source",
	"document_source_page" (int)
}

Les événements militaire:
{
	"event_kind": "Événement militaire",
	"start_date",
	"end_date", (si applicable)
	"location",
	"engagement_type", (affrontement, fortification, ...)
	"commander",
	"executing_unit",
	"order",
	"target", (si applicable)
	"outcome", (si applicable)
	"description",
	"title",
	"document_source",
	"document_source_page" (int)
 }
""",
    description="Extraits les événements militaire du document",
    output_key="extracted_events_agent_tool_output",
    tools=[get_document_page],
    before_model_callback=calculate_req_size,
)
