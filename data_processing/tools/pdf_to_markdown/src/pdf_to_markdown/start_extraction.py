from pathlib import Path
from pdf_to_markdown.cli_pdf_to_markdown import pdfToMarkdown

to_process = [
    {"title": "Historique du 15ème régiment d'infanterie.pdf", "start": 4, "end": 17},
    {"title": "Historique du 16ème régiment d'infanterie.pdf", "start": 3, "end": 24},
    {"title": "Historique du 18ème régiment d'infanterie.pdf", "start": 3, "end": 23},
]

storage_path = "../../../documents/regiments/markdown"


def main():
    total = len(to_process)
    for index, regiment in enumerate(to_process, start=1):
        pdf_path = Path("../../../documents/regiments/pdf") / regiment["title"]
        filename = pdf_path.stem
       
        print(f"{index}/{total}: {regiment}")
        pdfToMarkdown(
            pdf_filepath=str(pdf_path),
            md_output_filepath=f"{storage_path}/{filename}.md",
            start_at=regiment["start"],
            end_at=regiment["end"],
            verbose=True,
        )


if __name__ == "__main__":
    main()
