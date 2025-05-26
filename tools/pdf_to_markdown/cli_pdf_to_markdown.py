import argparse
import re

from google import genai
from google.genai import types

from utils.tempdir import TmpDir
from utils.file_reader import FileReader
from utils.pdf_to_images import pdfToImages

from config import GEMINI_API_KEY

client = genai.Client(api_key=GEMINI_API_KEY)


def geminiImageToMarkdown(image_path: str):
    prompt = FileReader.readFile("prompts/page_to_text.txt")
    file = client.files.upload(file=image_path)

    response = client.models.generate_content(
        model="gemini-2.0-flash",
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
    pages_to_skip: list[int] = [],
    verbose: bool = False,
):
    pages_img_paths = pdfToImages(pdf_filepath)
    total_images = len(pages_img_paths)
    for index in range(0, total_images - 1):
        page_text = ""
        if index not in pages_to_skip:
            image_path = pages_img_paths[index]
            page_text = geminiImageToMarkdown(image_path)
        with open(md_output_filepath, "a") as output_file:
            output_file.write(f"<!-- page: {index + 1} -->\n")
            output_file.write(f"{page_text}\n\n")
        if verbose:
            print(f"page {index}/{total_images - 1}")


def main():
    parser = argparse.ArgumentParser(
        prog="ProgramName",
        description="What the program does",
        epilog="Text at the bottom of help",
    )
    parser.add_argument("pdf_input_file", help="Pdf to extract")
    parser.add_argument("md_output_file", help="Markdown output file")
    parser.add_argument("-s", "--skip-pages", default="")
    parser.add_argument("-v", "--verbose", action="store_true", default=False)
    args = parser.parse_args()

    pagesToSkip = [int(page) - 1 for page in args.skip_pages.split(",") if page.strip()]
    pdfToMarkdown(
        pdf_filepath=args.pdf_input_file,
        md_output_filepath=args.md_output_file,
        pages_to_skip=pagesToSkip,
        verbose=args.verbose,
    )
    TmpDir.dispose()


if __name__ == "__main__":
    main()