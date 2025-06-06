from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.tools import agent_tool, ToolContext

from tools.extract_events_from_document.src.extract_events_from_document.config import ADVANCED_MODEL
from multi_tool_agent.events_extractor_manager_agent.agents.event_extractor_agent_tool import (
    event_extractor_agent_tool,
)
from multi_tool_agent.events_extractor_manager_agent.tools.set_extracted_events import (
    set_extracted_events,
    get_extracted_events
)
from multi_tool_agent.utils.calculate_model_call_size import calculate_req_size

event_extractor_manager_agent = LlmAgent(
    name="EventExtractorAgentManager",
    model=ADVANCED_MODEL,
    description="Extraits les événements puis stock les.",
    instruction="""
 **Objectif de ta mission :**
Tu dois extraire les pages `{page_interval?}` d'un document `{source_doc?}` et identifier les événements **MILITAIRE** historiques à l’aide du tool `event_extractor_agent_tool`.
Ce tool extrait les événements présents dans un segment de texte défini par une plage de pages.
**Les événements extraits avec le tool doivent être ajoutés à `{extracted_events?}` avec le tool `set_extracted_events`.**
**utilise le tool get_extracted_events pour récupérer les events de `{extracted_events?}`.**


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
    2 - Récupération des événements avec `event_extractor_agent_tool`.
    3 - Ajoute la liste des événements trouvés à `{extracted_events?}`:
      a - Récupération des du cotenu de `{extracted_events?}` avec le tool `get_extracted_events`.
      b - Stockage du contenu précédant et des nouveaux évents dans `{extracted_events?}` avec `set_extracted_events`.

- Exemples :
  `{page_interval?}` == "0-0"  
      1 - set `{page_interval?}` = "1-2"
      2 - Evénements récupérés = [
        {"title": "Bataille de la marne"},
        {"title": "Stabilisation du front"}
      ] a
      3.a - Récupération du contenue de `get_extracted_events`() = []
      3.b - Mise à jour de `{extracted_events?}` :
          `set_extracted_events`([
            {"title": "Bataille de la marne"},
            {"title": "Stabilisation du front"}
          ]).

  `{page_interval?}` == "1-2"  
      1 - set `{page_interval?}` = "2-3"
      2 - Evénements récupérés = [
        {"title": "Déclaration de guerre"},
        {"title": "Défense de Paris"}
      ]
      3.a - Récupération du contenue de `{extracted_events?}` `get_extracted_events`() = [
            {"title": "Bataille de la marne"},
            {"title": "Stabilisation du front"}
          ]
      3.b - Mise à jour de `{extracted_events?}` :
        `set_extracted_events`([
          {"title": "Bataille de la marne"},
          {"title": "Stabilisation du front"},
          {"title": "Déclaration de guerre"},
          {"title": "Défense de Paris"}
        ]).

**Utilisation des tools :**
À chaque itération, appelle `event_extractor_agent_tool` avec comme paramètre une string "`{source_doc?}` `{page_interval?}`" et
ajoute les résultats à `{extracted_events?}` avec `set_extracted_events` en oubliant pas que ce tool supprime le contenu précédant.
Il faudra donc récupérer le contenu précédant, l'ajouter au nouveau puis stocker le tout.

**Rappel :**
Concentre-toi sur l’exhaustivité et la rigueur historique.
""",
    tools=[
        agent_tool.AgentTool(agent=event_extractor_agent_tool, skip_summarization=True),
        set_extracted_events,
        get_extracted_events,
    ],
    before_model_callback=calculate_req_size,
)
