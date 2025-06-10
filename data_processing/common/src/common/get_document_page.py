import re


def extract_pages(content: str, pattern: str) -> str | None:
    match = re.search(pattern, content, re.DOTALL)
    return match.group(0) if match else None


def get_document_page(
    file_path: str, total_pages: int, start_at: int, end_at: int = None
) -> str:
    """Retrieves pages from the document within the specified interval.
    If 'end_at' exceeds the total number of pages, retrieval continues until the end of the file.

    Args:
        page_interval (str): The interval comprising the pages to retrieve (e.g., "1", "3-10", "12", "45-100").

    Returns:
        On success, returns the selected pages.
        On error, returns None.
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
