remove_duplicate_events_instructions = """

Ton objectif est de trouver les doublons issues d'une page cible, présent dans la liste d'événements `all_events`.
Tu retournera toujours une liste d'événements au format json.

1. Récupère tout les événements de `all_events` ayant pour `document_source_page` la page cible.
**Si `all_events` ne contient pas d'événements liés à la page cible, alors retourne directement la liste d'événements**

2. **Recherche de doublons (sur les événements de la page cible)**  
   - Comparer ces événements entre eux (mêmes attributs essentiels : titre, date, lieu, etc.) afin d’identifier d’éventuels doublons.  
   - **Si aucun doublon n’est trouvé retourne la liste d'événements**

3. **Fusion des événements (sur les événements de la page cible)**  
   a. Pour chaque groupe de doublons fusionnables, créer un **nouvel événement enrichi** (par ex. : combiner les descriptions, remplir les champs manquants).  
   c. Ajouter ces nouveaux événements fusionnés à la liste d'événements `all_events` en supprimants les évéments qu'ils ont pour origine et en consevant ceux qui ne font pas partis de la page cible.  

---

## Exemple 1 – événements similaires trouvés sur la page cible

**Input :**  
- `all_events` = [ 
    {title: "course à l'armement", document_source_page: 3},
    {title: "prise en étaux", document_source_page: 3},
    {title: "bataille du lac", document_source_page: 4},  
    {title: "repli stratégique vers le sud", document_source_page: 4},  
    {title: "bataille du lac de mercier", document_source_page: 4},
    {title: "repli stratégique", document_source_page: 4},
    {title: "attaque au gaz", document_source_page: 5},
    {title: "préparation des défenses", document_source_page: 5}
] 
- `page_cible` = 4

**Traitement détaillé :**

1. **Récupération des événements de la page cible**  
[
    {title: "bataille du lac", document_source_page: 4},
    {title: "repli stratégique vers le sud", document_source_page: 4},
    {title: "bataille du lac de mercier", document_source_page: 4},
    {title: "repli stratégique", document_source_page: 4},
]

2. **Recherche de doublons (parmi ces 4 événements)**  
- Doublons détectés :  
    {title: "bataille du lac", document_source_page: 4} similaire à {title: "bataille du lac de mercier", document_source_page: 4},
    {title: "repli stratégique vers le sud", document_source_page: 4} similaire à {title: "repli stratégique", document_source_page: 4},

3. **Fusion des événements :**  
    a. Fusion des éléments similaires :
    [
        {title: "repli stratégique vers le sud", document_source_page: 4},
        {title: "bataille du lac de mercier", document_source_page: 4}
    ]

    b. Return la list d'événements avec les doublons fusionnés:
    return [
        {title: "course à l'armement", document_source_page: 3},
        {title: "prise en étaux", document_source_page: 3},
        {title: "repli stratégique vers le sud", document_source_page: 4},
        {title: "bataille du lac de mercier", document_source_page: 4},
        {title: "attaque au gaz", document_source_page: 5},
        {title: "préparation des défenses", document_source_page: 5},
    ]
    
⸻

## Exemple 2 – aucun événement appartenant à la page cible

**Input :**  
- `all_events` = [
    {title: "course à l'armement", document_source_page: 3},
    {title: "prise en étaux", document_source_page: 3},
    {title: "attaque au gaz", document_source_page: 5},  
    {title: "préparation des défenses", document_source_page: 5}
]  
- `page_cible` = 4

**Traitement détaillé :**

1. **Aucun événement appartenant à la page cible trouvé, on return `all_events` **
    return [
        {title: "course à l'armement", document_source_page: 3},
        {title: "prise en étaux", document_source_page: 3},
        {title: "attaque au gaz", document_source_page: 5},  
        {title: "préparation des défenses", document_source_page: 5}
    ]  
    
⸻

## Exemple 3 – aucun événement similaire trouvé

**Input :**  
- `all_events` =  [
    {title: "course à l'armement", document_source_page: 3}
    {title: "prise en étaux", document_source_page: 3}
    {title: "bataille du lac", document_source_page: 4}
    {title: "repli stratégique", document_source_page: 4}
    {title: "attaque au gaz", document_source_page: 5}
    {title: "préparation des défenses", document_source_page: 5}
] 
- `page_cible` = 4

**Traitement détaillé :**

1. **Récupération des événements de la page cible **  
[
    {title: "bataille du lac", document_source_page: 4},
    {title: "repli stratégique", document_source_page: 4},
]

2. **Recherche de doublons (parmi ces 2 événements)**  
    - Aucun doublon détecté => return [
        {title: "course à l'armement", document_source_page: 3}
        {title: "prise en étaux", document_source_page: 3}
        {title: "bataille du lac", document_source_page: 4}
        {title: "repli stratégique", document_source_page: 4}
        {title: "attaque au gaz", document_source_page: 5}
        {title: "préparation des défenses", document_source_page: 5}
    ] 
"""
