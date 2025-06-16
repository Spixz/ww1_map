Convert the contents of a PDF made exclusively of images (scans) into a Markdown file that can be used by a LLM.

'''
uv sync
uv run pdf-to-markdown file.pdf output.md -start 4 -end 15
'''