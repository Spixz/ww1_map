from pdf2image import convert_from_path

from pdf_to_markdown.utils.tempdir import TmpDir


def pdfToImages(
    pdf_path: str, start_at: int | None = None, end_at: int | None = None
) -> list[str]:
    output_folder = TmpDir.createTempFolder()
    # output_folder = "tempImages" # à racine du package

    print("Start converting all the pdf into images before gemini OCR")
    images_paths = convert_from_path(
        pdf_path,
        first_page=start_at,
        last_page=end_at,
        output_folder=output_folder,
        output_file="",
        fmt="jpg",
        paths_only=True,
    )
    print("Pdf successfully converted into images !")
    return images_paths
