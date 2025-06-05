import re

def extract_pages(content: str, pattern: str) -> str | None:
    match = re.search(pattern, content, re.DOTALL)
    return match.group(0) if match else None


def get_document_page(file_path: str, page_interval: str) -> str:
    """Récupère dans le document les pages comprises dans l'intervalle.

    Args:
        page_interval (str): L'intervalle comprenant les pages à récupérer (e.g., "1", "3-10", "12", "45-100").

    Returns:
        En cas de succès return les pages sélectionnées
        En cas d'erreur return "error"
    """
    try:
        page_indexs: list[int] = [int(nb) for nb in page_interval.split("-")]
        nb_index_given = len(page_indexs)
        if nb_index_given == 0:
            return "error"
        start_at: int = page_indexs[0]
        end_at: int = start_at + 1 if nb_index_given == 1 else page_indexs[1] + 1
        expression = rf"<!-- page: {start_at} -->.*?(?=<!-- page: {end_at} -->|$)"

        with open(file_path, "r", encoding="utf-8") as file:
            content = file.read()
            extracted_pages = extract_pages(content=content, pattern=expression)
        if extracted_pages is None or (
            nb_index_given == 2
            and f"<!-- page: {page_indexs[1]} -->" not in extracted_pages
        ):
            return "error"
        return extracted_pages
    except Exception as e:
        print(e)
        return "error"