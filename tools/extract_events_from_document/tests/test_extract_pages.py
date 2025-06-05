import os
import tempfile
import json

from multi_tool_agent.events_extractor_agent.events_tools import get_document_page


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

    result = get_document_page(temp_file_path, "6")
    print(result)

    assert "error" not in result
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

    result = get_document_page(temp_file_path, "6")
    print(result)

    assert "error" not in result
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

    result = get_document_page(temp_file_path, "6-7")
    print(result)

    assert "error" not in result
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

    result = get_document_page(temp_file_path, "6-8")
    print(result)

    assert "error" not in result
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

    result = get_document_page(temp_file_path, "4")
    print(result)

    assert "error" in result
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

    result = get_document_page(temp_file_path, "4-5")
    print(result)

    assert "error" in result
    os.remove(temp_file_path)


def test_page_not_found_interval_end():
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

    result = get_document_page(temp_file_path, "7-9")
    print(result)

    assert "error" in result
    os.remove(temp_file_path)


def test_empty_page_parameter():
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

    result = get_document_page(temp_file_path, "")
    assert "error" in result
    os.remove(temp_file_path)


def test_unexisting_file():
    result = get_document_page("", "5-6")
    assert "error" in result


if __name__ == "__main__":
    test_select_only_one_page()
