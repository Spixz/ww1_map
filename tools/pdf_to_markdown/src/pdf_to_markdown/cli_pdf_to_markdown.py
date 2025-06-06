import argparse
import re
import os

from google import genai
from google.genai import types

from pdf_to_markdown.utils.tempdir import TmpDir
from pdf_to_markdown.utils.pdf_to_images import pdfToImages
from common import FileReader

from pdf_to_markdown.config import GEMINI_API_KEY, LESS_ADVANDED_MODEL

client = genai.Client(api_key=GEMINI_API_KEY)


def geminiImageToMarkdown(image_path: str):
    CURRENT_DIR = os.path.dirname(__file__)
    PROMPT_PATH = os.path.join(CURRENT_DIR, "prompts", "page_to_text.txt")
    prompt = FileReader.readFile(PROMPT_PATH)
    file = client.files.upload(file=image_path)

    response = client.models.generate_content(
        model=LESS_ADVANDED_MODEL,
        contents=[file],
        config=types.GenerateContentConfig(
            system_instruction=prompt,
        ),
    )
    text_response = response.text or ""
    return re.sub(r"```(?:markdown)?", "", text_response)


def pdfToMarkdown(
    *,
    pdf_filepath: str,
    md_output_filepath: str,
    start_at: int = 1,
    end_at: int | None = None,
    pages_to_skip: list[int] = [],
    verbose: bool = False,
):
    pages_img_paths = pdfToImages(pdf_filepath, start_at, end_at)
    total_images = len(pages_img_paths)
    for index in range(0, total_images):
        page_text = ""
        if index not in pages_to_skip:
            image_path = pages_img_paths[index]
            page_text = geminiImageToMarkdown(image_path)
        with open(md_output_filepath, "a") as output_file:
            output_file.write(f"<!-- page: {index + 1} -->\n")
            output_file.write(f"{page_text}\n\n")
        if verbose:
            print(f"page {index + 1}/{total_images - 1}")


def main():
    parser = argparse.ArgumentParser(
        prog="PdfToMarkdown",
        description="Convert a pdf containing only images to a markdown file using gemini",
    )
    parser.add_argument("pdf_input_file", help="Pdf to extract")
    parser.add_argument("md_output_file", help="Markdown output file")
    parser.add_argument(
        "-start", "--start-at", default=0, help="Page where the extraction begin"
    )
    parser.add_argument(
        "-end", "--end-at", default=None, help="Page where the extraction end"
    )
    parser.add_argument(
        "-s",
        "--skip-pages",
        default="",
        help="List of pages to skip during the convertion",
    )
    parser.add_argument("-v", "--verbose", action="store_true", default=True)
    args = parser.parse_args()

    pagesToSkip = [int(page) - 1 for page in args.skip_pages.split(",") if page.strip()]
    pdfToMarkdown(
        pdf_filepath=args.pdf_input_file,
        md_output_filepath=args.md_output_file,
        start_at=int(args.start_at),
        end_at=args.end_at if None else int(args.end_at),
        pages_to_skip=pagesToSkip,
        verbose=args.verbose,
    )
    TmpDir.dispose()


if __name__ == "__main__":
    main()
