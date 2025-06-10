from google.genai.types import (
    GenerateContentConfig,
    Tool,
    GoogleSearch,
    ThinkingConfig,
)

from common import (
    GeminiClientInstance,
    GeminiModels,
)


def web_search_tool(query: str):
    """
    Effectue une recherche Google sur une requête textuelle et retourne un résumé des résultats.

    Utilise cet outil lorsque tu veux trouver des informations historiques ou contextuelles

    Paramètre :
      - query (str) : la requête textuelle, ex. "Bois des Caures Verdun 1916 France"

    Retour :
      - Résumé textuel des résultats de recherche (str)
    """
    response = GeminiClientInstance().models.generate_content(
        model=GeminiModels.advanded_model,
        contents=query,
        config=GenerateContentConfig(
            tools=[Tool(google_search=GoogleSearch())],
            thinking_config=ThinkingConfig(
                include_thoughts=True, thinking_budget=24576
            ),
        ),
    )
    text_response = response.text or ""  # .pars
    return text_response
