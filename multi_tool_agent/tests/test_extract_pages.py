
import os
import tempfile
import json
from events_extractor_agent.events_tools import get_document_page


from config import SOURCE_DOC

def set_source_doc(path: str):
    global SOURCE_DOC
    SOURCE_DOC = path


def create_temp_file(content: str) -> str:
    tmp = tempfile.NamedTemporaryFile(delete=False, mode="w", encoding="utf-8")
    tmp.write(content)
    tmp.close()
    return tmp.name


def test_valid_page_range():
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
    path = create_temp_file(content)
    set_source_doc(path=path)

    result = get_document_page("6-7")
    parsed = json.loads(result)

    assert parsed["status"] == "success"
    assert "Début" in parsed["text"]
    assert "Fin" in parsed["text"]
    assert "page 8 content" not in parsed["text"]
    os.remove(path)


# def test_single_page():
#     content = """
#     <!-- page: 6 -->
#     Page unique
#     <!-- page: 7 -->
#     """
#     path = create_temp_file(content)
#     pages_module.SOURCE_DOC = path

#     result = get_document_page("6")
#     parsed = json.loads(result)

#     assert parsed["status"] == "success"
#     assert "Page unique" in parsed["text"]
#     os.remove(path)


# def test_invalid_range():
#     result = get_document_page("bad-input")
#     parsed = json.loads(result)

#     assert parsed["status"] == "error"
#     assert parsed["text"] is None