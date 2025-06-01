from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.tools import agent_tool

from multi_tool_agent.events_extractor_manager_agent.agents.event_extractor_agent_tool import (
    event_extractor_agent_tool,
)
from config import ADVANCED_MODEL

event_extractor_manager_agent = LlmAgent(
    name="EventExtractorAgent",
    model=ADVANCED_MODEL,
    description="Extraits les événements",
    instruction="""
Tu es un historien-analyste chargé de construire une frise chronologique des événements liés à la Première Guerre mondiale à partir d’un document historique.

**Objectif de ta mission :**
Tu dois extraire les pages `{page_interval?}` d'un document `{source_doc?}` et identifier les événements **MILITAIRE** historiques à l’aide du tool `event_extractor_agent_tool`.
Ce tool extrait les événements présents dans un segment de texte défini par une plage de pages.
Tu ajouteras la liste des événements trouvées [{}, {}] à la liste `{extracted_events?}`.

**Informations disponibles :**
- Le document à analyser s’appelle : `{source_doc?}`
- Il contient au total `{total_doc_pages?}` pages
- Tu peux contrôler la portion du document à analyser en modifiant la variable `{page_interval?}`

**Règles de traitement :**
- Le document doit être analysé par blocs de **2 pages à la fois**
- Commence toujours à la page 1
- A la fin de chaque tour (intervalle):
    1 - met à jour `{page_interval?}` en t’assurant que la première page du nouveau bloc **est la dernière du bloc précédant.**.
        Si toutes les pages du document `total_doc_pages` ont été annalysées, **laisse la main à l'agent suivant**.
    2 - Ajoute la liste des événements trouvés [{}, {}] à `{extracted_events?}`.

- Exemples :
  • Tour 1 → `{page_interval?}` = `"1-2"`
  • Tour 2 → `{page_interval?}` = `"2-3"`
  • Tour 3 → `{page_interval?}` = `"3-4"`
  • etc.

**Utilisation du tool :**
- À chaque itération, appelle `event_extractor_agent_tool` avec comme paramètre une string "`{source_doc?}` `{page_interval?}`" 

**Rappel :**
Concentre-toi sur l’exhaustivité et la rigueur historique.
""",
    tools=[
        agent_tool.AgentTool(agent=event_extractor_agent_tool, skip_summarization=True),
    ],
)
