import os
import tempfile
import json

from extract_events_from_document.get_document_page import get_document_page


def create_temp_file(content: str) -> str:
    tmp = tempfile.NamedTemporaryFile(delete=False, mode="w", encoding="utf-8")
    tmp.write(content)
    tmp.close()
    return tmp.name


def test_select_only_one_page():
    content = """
<!-- page: 5 -->
Intro
<!-- page: 6 -->
Début
<!-- page: 7 -->
Fin
<!-- page: 8 -->
page 8 content
"""
    temp_file_path = create_temp_file(content)

    result = get_document_page(temp_file_path, total_pages=10, start_at=6)
    print(result)

    assert result is not None
    assert "<!-- page: 6 -->\nDébut" in result.strip()
    os.remove(temp_file_path)


def test_select_only_one_page_end_of_file():
    content = """
<!-- page: 5 -->
Intro
<!-- page: 6 -->
Début
Fin
"""
    temp_file_path = create_temp_file(content)

    result = get_document_page(temp_file_path, total_pages=6, start_at=6)
    print(result)

    assert result is not None
    assert "<!-- page: 6 -->\nDébut\nFin" in result.strip()
    os.remove(temp_file_path)


def test_select_interval():
    content = """
<!-- page: 5 -->
Intro
<!-- page: 6 -->
Début
<!-- page: 7 -->
Fin
<!-- page: 8 -->
page 8 content
"""
    temp_file_path = create_temp_file(content)

    result = get_document_page(temp_file_path, total_pages=10, start_at=6, end_at=7)
    print(result)

    assert result is not None
    assert "<!-- page: 6 -->\nDébut\n<!-- page: 7 -->\nFin" in result.strip()
    os.remove(temp_file_path)


def test_select_interval_end_of_page():
    content = """
<!-- page: 5 -->
Intro
<!-- page: 6 -->
Début
<!-- page: 7 -->
Fin
<!-- page: 8 -->
page 8 content
"""
    temp_file_path = create_temp_file(content)

    result = get_document_page(temp_file_path, total_pages=10, start_at=6, end_at=8)
    print(result)

    assert result is not None
    assert (
        "<!-- page: 6 -->\nDébut\n<!-- page: 7 -->\nFin\n<!-- page: 8 -->\npage 8 content"
        in result.strip()
    )
    os.remove(temp_file_path)


def test_page_not_found():
    content = """
<!-- page: 5 -->
Intro
<!-- page: 6 -->
Début
<!-- page: 7 -->
Fin
<!-- page: 8 -->
page 8 content
"""
    temp_file_path = create_temp_file(content)

    result = get_document_page(temp_file_path, total_pages=10, start_at=4)
    print(result)

    assert result is None
    os.remove(temp_file_path)


def test_page_not_found_interval():
    content = """
<!-- page: 5 -->
Intro
<!-- page: 6 -->
Début
<!-- page: 7 -->
Fin
<!-- page: 8 -->
page 8 content
"""
    temp_file_path = create_temp_file(content)

    result = get_document_page(temp_file_path, total_pages=10, start_at=4, end_at=5)
    print(result)

    assert result is None
    os.remove(temp_file_path)

def test_end_on_last_page():
    content = """
<!-- page: 5 -->
Intro
<!-- page: 6 -->
Début
<!-- page: 7 -->
Fin
<!-- page: 8 -->
page 8 content
<!-- page: 9 -->
page 9 content
<!-- page: 10 -->
page 10 content (last page)
"""
    temp_file_path = create_temp_file(content)

    result = get_document_page(temp_file_path, total_pages=10, start_at=6, end_at=10)
    print(result)

    assert result is not None
    assert "page 10 content (last page)" in result.strip()
    os.remove(temp_file_path)

def test_last_page_index_overflow():
    content = """
<!-- page: 5 -->
Intro
<!-- page: 6 -->
Début
<!-- page: 7 -->
Fin
<!-- page: 8 -->
page 8 content
<!-- page: 9 -->
page 9 content
<!-- page: 10 -->
page 10 content (last page)
"""
    temp_file_path = create_temp_file(content)

    result = get_document_page(temp_file_path, total_pages=10, start_at=6, end_at=11)
    print(result)

    assert result is not None
    assert "page 10 content (last page)" in result.strip()
    os.remove(temp_file_path)


def test_unexisting_file():
    result = get_document_page("", total_pages=10, start_at=5, end_at=6)
    assert result is None


if __name__ == "__main__":
    test_last_page_index_overflow()
