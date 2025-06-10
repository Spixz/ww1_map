For each event in the database with no existing `coordinates` field, determine the precise GPS location and add it to the coordinates field.

```
uv sync
uv run events-location-finder ../../documents/regiments/markdown
```