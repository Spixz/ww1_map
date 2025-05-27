from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.tools import ToolContext, agent_tool
from pydantic import BaseModel, Field
from multi_tool_agent.events_extractor_manager_agent.agents.event_extractor_agent_tool import (
    event_extractor_agent_tool,
)
from config import GEMINI_2_FLASH


event_extractor_manager_agent = LlmAgent(
    name="EventExtractorAgent",
    model=GEMINI_2_FLASH,
    description="Extraits les événements",
    instruction="""
Tu es un historien-analyste chargé de construire une frise chronologique des événements liés à la Première Guerre mondiale à partir d’un document historique.

**Objectif de ta mission :**
Tu dois parcourir un document complet, page par page, et identifier les événements historiques à l’aide du tool `event_extractor_agent_tool`. Ce tool extrait les événements présents dans un segment de texte défini par une plage de pages.

**Informations disponibles :**
- Le document à analyser s’appelle : `{source_doc?}`
- Il contient au total `{total_doc_pages?}` pages
- Tu peux contrôler la portion du document à analyser en modifiant la variable `{page_interval?}`

**Règles de traitement :**
- Le document doit être analysé par blocs de **5 pages à la fois**
- Commence toujours à la page 1
- À chaque nouveau tour, tu dois mettre à jour `{page_interval?}` en t’assurant que la première page du nouveau bloc **reprend là où le précédent s’est arrêté moins une page**
- Exemples :
  • Tour 1 → `{page_interval?}` = `"1-5"`  
  • Tour 2 → `{page_interval?}` = `"5-9"`  
  • Tour 3 → `{page_interval?}` = `"9-13"`  
  • etc.

**Utilisation du tool :**
- À chaque itération, appelle `event_extractor_agent_tool` avec comme parametre "/Users/cyril/projets/ww1_map/documents/books/la_grande_guerre_sur_le_front_occidental/markdown/tome_2.md, 1-5"
- Le résultat sera une liste d'événements extraits, ou une liste vide s'il n’y a rien à signaler
- Ne saute aucune page : parcours l’intégralité du document en suivant les règles ci-dessus

**Rappel :**
Tu es responsable de t’assurer que chaque portion du document est analysée dans le bon ordre, sans doublons, ni oublis. Concentre-toi sur l’exhaustivité et la rigueur historique.
""",
    output_key="extracted_events",
    tools=[
        agent_tool.AgentTool(agent=event_extractor_agent_tool, skip_summarization=True)
    ],
)
