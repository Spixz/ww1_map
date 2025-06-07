import re


def extract_pages(content: str, pattern: str) -> str | None:
    match = re.search(pattern, content, re.DOTALL)
    return match.group(0) if match else None


def get_document_page(
    file_path: str, total_pages: int, start_at: int, end_at: int = None
) -> str:
    """Récupère dans le document les pages comprises dans l'intervalle.
    Si end_at dépasse le nombre de pages, alors la récupération ce fait jusqu'à la fin du fichier.

    Args:
        page_interval (str): L'intervalle comprenant les pages à récupérer (e.g., "1", "3-10", "12", "45-100").

    Returns:
        En cas de succès return les pages sélectionnées
        En cas d'erreur return None
    """
    try:
        expression = None
        end_at_calculated = start_at + 1 if end_at is None else end_at + 1
        if end_at_calculated >= total_pages:
            end_at_calculated = total_pages
            expression = rf"<!-- page: {start_at} -->.*"
        else:
            expression = (
                rf"<!-- page: {start_at} -->.*?(?=<!-- page: {end_at_calculated} -->|$)"
            )

        with open(file_path, "r", encoding="utf-8") as file:
            content = file.read()
            extracted_pages = extract_pages(content=content, pattern=expression)
        return extracted_pages
    except Exception as e:
        print(e)
        return None
