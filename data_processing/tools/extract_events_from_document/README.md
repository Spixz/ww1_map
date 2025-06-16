Generate a description of the regiment using prompt `create_regiment_description_instruction.txt`, based on the regiment_history.md file.
Go through each page of the regimental history, extract three types of events using the prompt `extract_events_instruction.txt`, and store them in a MongoDB database.

```
cd tools

uv run extract-events-from-document ../common/../../documents/regiments/markdown/18_eme_regiment_infanterie.md

# Tests
uv run pytest extract_events_from_document/tests/test_extract_pages.py
```
