from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.tools import ToolContext, agent_tool

from config import GEMINI_2_FLASH
from multi_tool_agent.events_extractor_manager_agent.tools.get_document_page import (
    get_document_page,
)


# STATES INDEXES
STATE_LAST_EXTRACTED_PAGE_NUMBER = "last_extracted_page_number"


# TODO : Faire qu'il suive un schéma
event_extractor_agent_tool = LlmAgent(
    name="EventExtractorAgent",
    model="gemini-2.5-flash-preview-05-20",
    instruction="""

Ce tool prend un parameter une seule string "filepath_du_document, intervalle"
Tu es un historien expert chargé de construire une frise chronologique des événements liés à la Première Guerre mondiale à partir d’un document source.

Le texte du document est accessible grâce au tool `get_document_page`, qui prend deux paramètres :
- `{source_doc?}` : le nom du document,
- `{page_interval?}` : l’intervalle de pages à examiner.

**Ta mission** :
1. Récupère le texte via `get_document_page`({source_doc?}, {page_interval?}).
2. Analyse ce texte pour identifier des événements historiques pertinents.
3. Pour chaque événement identifié, crée un objet structuré correspondant à l’un des types d’événements définis ci-dessous.

⚠️ Règles importantes :
- Si un champ ne s'applique pas, définis-le explicitement à `null`.
- Les dates doivent être au format **"%Y-%m-%d %H:%M:%S"**.
- Le champ `document_source` doit contenir **"titre_du_document, page"**.
- Résume la description dans le champ `title` ou `titre`, selon le type d’événement.
- Retourne une **liste d’événements** sous la forme `[{...}, {...}]`, ou une **`aucun évènement trouvé`** si aucun événement n’est trouvé.


Les événements politiques : 
{
	"type": "Événement politique",
	"start_date", 
	"end_date", (si applicable)
	"description",
	"title", (résumé de la description)
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
""",
    description="Extraits les événements",
    output_key="extracted_events",
    tools=[get_document_page],
)
