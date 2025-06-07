## extract_regiments.violentmonkey.js
Retrieve the ARK IDs of all infantry regiment histories, along with the number of media items in each document.
The list is saved in `regiments_list.json`.

## fetch_pages.py
For each regiment history listed in `regiments_list.json`, fetch the URL of every scanned page
and store the results in `regiments_complet.json`.
For some regiments in this list (+3 batches), the PDFs were retrieved manually.

The following regiments do not have a PDF file. The photo scans need to be used directly:
- History of the 12th Infantry Regiment
- History of the 24th Infantry Regiment
- History of the 131st Infantry Regiment
- History of the 297th Infantry Regiment
- History of the 353rd Infantry Regiment

## store_regiment_in_db.py
Store each elements of `regiments_complet.json` inside the mongodb database.