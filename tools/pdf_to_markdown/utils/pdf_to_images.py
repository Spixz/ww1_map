from pdf2image import convert_from_path

from utils.tempdir import TmpDir

def pdfToImages(pdf_path: str) -> list[str]:
    output_folder = TmpDir.createTempFolder()

    print("Start pdf to images conversion")
    images_paths = convert_from_path(
        pdf_path,
        output_folder=output_folder,
        output_file="",
        fmt="jpg",
        paths_only=True,
    )
    print("Pdf to images conversion done")
    return images_paths
