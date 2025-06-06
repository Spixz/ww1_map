from typing import Optional

from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.agents.callback_context import CallbackContext
from google.genai.types import Content

from tools.extract_events_from_document.src.extract_events_from_document.config import ADVANCED_MODEL
from multi_tool_agent.events_extractor_manager_agent.tools.set_extracted_events import (
    set_extracted_events,
)
from multi_tool_agent.utils.calculate_model_call_size import calculate_req_size


# def _after_tool_callback(
#     tool: BaseTool, args: dict[str, Any], tool_context: ToolContext, tool_response: dict
# ) -> Optional[dict]:
#     tool_context.state["extracted_events"] = []
#     tool_context.state["remove_doublon_output"] = []


def _before_agent_callback(callback_context: CallbackContext) -> Optional[Content]:
    print("CONTENU DE EXTRACTED_EVENTS AVANT LA SUPPRESSION DES DOUBLONS")
    print(callback_context.state.get("extracted_events"))
    return None


remove_duplicate_events_agent = LlmAgent(
    name="RemoveDuplicateEventAgent",
    model=ADVANCED_MODEL,
    instruction="""

Ton objectif est de trouver les doublons présent dans `{extracted_events}`.
** Pour modifier la valeur de {extracted_events} tu utilisera le tool `set_extracted_events` qui supprime la valeur
précédante de {extracted_events}. en oubliant pas que ce tool supprime le contenu précédant.
Il faudra donc récupérer le contenu précédant, l'ajouter au nouveau puis stocker le tout.

1. **Déterminer la page cible**
   La page cible est **TOUJOURS** la première page de l’intervalle `{page_interval}`.

2. **Récupérer les événements de `{extracted_events}`**  
   Extraire tous les événements dont `document_source_page` correspond à la page cible.

3. **Si aucun événement n’est lié à cette page, passage à l'agent suivant**  

4. **Recherche de doublons (sur les événements de la page cible)**  
   - Comparer ces événements entre eux (mêmes attributs essentiels : titre, date, lieu, etc.) afin d’identifier d’éventuels doublons.  
   - **Si aucun doublon n’est trouvé passage à l'agent suivant**

5. **Fusion des événements (sur les événements de la page cible)**  
   a. Retirer **tous les doublons identifiés** de la liste `{extracted_events}` avec `set_extracted_events`.  
   b. Pour chaque groupe de doublons fusionnables, créer un **nouvel événement enrichi** (par ex. : combiner les descriptions, remplir les champs manquants).  
   c. Ajouter ces nouveaux événements fusionnés à `{extracted_events}` avec `set_extracted_events`.  

---

## Exemple 1 – événements similaires trouvés sur la page cible

**Input :**  
- `extracted_events` = [ 
    {title: "course à l'armement", document_source_page: 3},
    {title: "prise en étaux", document_source_page: 3},
    {title: "bataille du lac", document_source_page: 4},  
    {title: "repli stratégique vers le sud", document_source_page: 4},  
    {title: "bataille du lac de mercier", document_source_page: 4},
    {title: "repli stratégique", document_source_page: 4},
    {title: "attaque au gaz", document_source_page: 5},
    {title: "préparation des défenses", document_source_page: 5}
] 
- `page_interval` = [4 – 5]

**Traitement détaillé :**

1. ** Déterminer la page cible 4**
    `page_interval` = [4 – 5] => page cible = 4
2. **Récupération des événements de la page cible**  
[
    {title: "bataille du lac", document_source_page: 4},
    {title: "repli stratégique vers le sud", document_source_page: 4},
    {title: "bataille du lac de mercier", document_source_page: 4},
    {title: "repli stratégique", document_source_page: 4},
]

3. **Événements trouvés : on passe à l’étape suivante.**

4. **Recherche de doublons (parmi ces 4 événements)**  
- Doublons détectés :  
    {title: "bataille du lac", document_source_page: 4} similaire à {title: "bataille du lac de mercier", document_source_page: 4},
    {title: "repli stratégique vers le sud", document_source_page: 4} similaire à {title: "repli stratégique", document_source_page: 4},

5. **Fusion des événements :**  
    a. Retirer les 4 doublons de `extracted_events`
    `set_extracted_events`([
        {title: "course à l'armement", document_source_page: 3},
        {title: "prise en étaux", document_source_page: 3},
        {title: "attaque au gaz", document_source_page: 5},
        {title: "préparation des défenses", document_source_page: 5},
    ])
    
    b. Fusion des éléments similaires :
    [
        {title: "repli stratégique vers le sud", document_source_page: 4},
        {title: "bataille du lac de mercier", document_source_page: 4}
    ]

    c. Réinsertion des événements fusionnés dans `extracted_events`:
    `set_extracted_events`([
        {title: "course à l'armement", document_source_page: 3},
        {title: "prise en étaux", document_source_page: 3},
        {title: "repli stratégique vers le sud", document_source_page: 4},
        {title: "bataille du lac de mercier", document_source_page: 4},
        {title: "attaque au gaz", document_source_page: 5},
        {title: "préparation des défenses", document_source_page: 5},
    ])
    
⸻

## Exemple 2 – aucun événement appartenant à la page cible

**Input :**  
- `extracted_events` = [
    {title: "course à l'armement", document_source_page: 3},
    {title: "prise en étaux", document_source_page: 3},
    {title: "attaque au gaz", document_source_page: 5},  
    {title: "préparation des défenses", document_source_page: 5}
]  
- `page_interval` = [4 – 5]

**Traitement détaillé :**

1. ** Déterminer la page cible **
    `page_interval` = [4 – 5] => page cible = 4
2. **Récupération des événements de la page cible**  
[]

3. **Aucun événement trouvé, on passe la main à l'agent suivant **



## Exemple 3 – aucun événement similaire trouvé

**Input :**  
- `extracted_events` =  [
    {title: "course à l'armement", document_source_page: 3}
    {title: "prise en étaux", document_source_page: 3}
    {title: "bataille du lac", document_source_page: 4}
    {title: "repli stratégique", document_source_page: 4}
    {title: "attaque au gaz", document_source_page: 5}
    {title: "préparation des défenses", document_source_page: 5}
] 
- `page_interval` = [4 – 5]

**Traitement détaillé :**

1. ** Déterminer la page cible **
    `page_interval` = [4 – 5] => page cible = 4
2. **Récupération des événements de la page cible **  
[
    {title: "bataille du lac", document_source_page: 4},
    {title: "repli stratégique", document_source_page: 4},
]

3. **Événements trouvés : on passe à l’étape suivante.**

4. **Recherche de doublons (parmi ces 2 événements)**  
- Aucun doublon détecté => passage à l'agent suivant


""",
    description="Recherche les doublons d'une page cible dans `{extracted_events}`, puis les fusionne.",
    tools=[set_extracted_events],
    before_agent_callback=_before_agent_callback,
    output_key="remove_doublon_output",
)


# remove_duplicate_events_agent = LlmAgent(
#     name="RemoveDuplicateEventAgent",
#     model=ADVANCED_MODEL,
#     instruction="""

# 1. **Déterminer la page cible**
#    La page cible est **TOUJOURS** la première page de l’intervalle `{page_interval}`.

# 2. **Récupérer les événements de `{extracted_events}`**
#    Extraire tous les événements dont `document_source_page` correspond à la page cible.

# 3. **Si aucun événement n’est lié à cette page, laisser la main au tool suivant**
#    → Fin du traitement.

# 4. **Recherche de doublons (sur les événements de la page cible)**
#    - Comparer ces événements entre eux (mêmes attributs essentiels : titre, date, lieu, etc.) afin d’identifier d’éventuels doublons.
#    - **Si aucun doublon n’est trouvé**, laisser la main au tool suivant.

# 5. **Fusion des événements (sur les événements de la page cible)**
#    a. Retirer **tous les doublons identifiés** de la liste `{extracted_events}`.
#    b. Pour chaque groupe de doublons fusionnables, créer un **nouvel événement enrichi** (par ex. : combiner les descriptions, remplir les champs manquants).
#    c. Ajouter ces nouveaux événements fusionnés à `{extracted_events}`.
#    d. Laisser la main au tool suivant.

# ---

# ## Exemple 1 – événements similaires trouvés sur la page cible

# **Input :**
# - `extracted_events` = [
#     {title: "course à l'armement", document_source_page: 3},
#     {title: "prise en étaux", document_source_page: 3},
#     {title: "bataille du lac", document_source_page: 4},
#     {title: "repli stratégique vers le sud", document_source_page: 4},
#     {title: "bataille du lac de mercier", document_source_page: 4},
#     {title: "repli stratégique", document_source_page: 4},
#     {title: "attaque au gaz", document_source_page: 5},
#     {title: "préparation des défenses", document_source_page: 5}
# ]
# - `page_interval` = [4 – 5]

# **Traitement détaillé :**

# 1. ** Déterminer la page cible 4**
#     `page_interval` = [4 – 5] => page cible = 4
# 2. **Récupération des événements de la page cible**
# [
#     {title: "bataille du lac", document_source_page: 4},
#     {title: "repli stratégique vers le sud", document_source_page: 4},
#     {title: "bataille du lac de mercier", document_source_page: 4},
#     {title: "repli stratégique", document_source_page: 4},
# ]

# 3. **Événements trouvés : on passe à l’étape suivante.**

# 4. **Recherche de doublons (parmi ces 4 événements)**
# - Doublons détectés :
#     {title: "bataille du lac", document_source_page: 4} similaire à {title: "bataille du lac de mercier", document_source_page: 4},
#     {title: "repli stratégique vers le sud", document_source_page: 4} similaire à {title: "repli stratégique", document_source_page: 4},

# 5. **Fusion des événements :**
#     a. Retirer les 4 doublons de `extracted_events`
#     `extracted_events` = [
#         {title: "course à l'armement", document_source_page: 3},
#         {title: "prise en étaux", document_source_page: 3},
#         {title: "attaque au gaz", document_source_page: 5},
#         {title: "préparation des défenses", document_source_page: 5},
#     ]

#     b. Fusion des éléments similaires :
#     [
#         {title: "repli stratégique vers le sud", document_source_page: 4},
#         {title: "bataille du lac de mercier", document_source_page: 4}
#     ]

#     c. Réinsertion des événements fusionnés dans `extracted_events`:
#     [
#         {title: "course à l'armement", document_source_page: 3},
#         {title: "prise en étaux", document_source_page: 3},
#         {title: "repli stratégique vers le sud", document_source_page: 4},
#         {title: "bataille du lac de mercier", document_source_page: 4},
#         {title: "attaque au gaz", document_source_page: 5},
#         {title: "préparation des défenses", document_source_page: 5},
#     ]

#     d. Passage au tool suivant

# ⸻

# ## Exemple 2 – aucun événement appartenant à la page cible

# **Input :**
# - `extracted_events` = [
#     {title: "course à l'armement", document_source_page: 3},
#     {title: "prise en étaux", document_source_page: 3},
#     {title: "attaque au gaz", document_source_page: 5},
#     {title: "préparation des défenses", document_source_page: 5}
# ]
# - `page_interval` = [4 – 5]

# **Traitement détaillé :**

# 1. ** Déterminer la page cible **
#     `page_interval` = [4 – 5] => page cible = 4
# 2. **Récupération des événements de la page cible**
# []

# 3. **Aucun événement trouvé : passage immédiat au tool suivant.**


# ## Exemple 3 – aucun événement similaire trouvé

# **Input :**
# - `extracted_events` =  [
#     {title: "course à l'armement", document_source_page: 3}
#     {title: "prise en étaux", document_source_page: 3}
#     {title: "bataille du lac", document_source_page: 4}
#     {title: "repli stratégique", document_source_page: 4}
#     {title: "attaque au gaz", document_source_page: 5}
#     {title: "préparation des défenses", document_source_page: 5}
# ]
# - `page_interval` = [4 – 5]

# **Traitement détaillé :**

# 1. ** Déterminer la page cible **
#     `page_interval` = [4 – 5] => page cible = 4
# 2. **Récupération des événements de la page cible **
# [
#     {title: "bataille du lac", document_source_page: 4},
#     {title: "repli stratégique", document_source_page: 4},
# ]

# 3. **Événements trouvés : on passe à l’étape suivante.**

# 4. **Recherche de doublons (parmi ces 2 événements)**
# - Aucun doublon détecté

# 5. **Pas de fusion nécessaire : passage au tool suivant.**

# """,
#     description="Recherche les doublons d'une page cible dans `{extracted_events}`, puis les fusionne.",
#     before_model_callback=calculate_req_size,
# )
