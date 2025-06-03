import json
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import List
import requests


@dataclass
class Medias:
    pages: list[str] | None
    pdf: str | None


@dataclass
class RegimentInput:
    title: str
    ark_name: str
    nb_medias: int


@dataclass
class RegimentOutput:
    title: str
    ark_name: str
    nb_medias: int
    medias: Medias


def load_historique(path: Path) -> List[RegimentInput]:
    with path.open("r", encoding="utf-8") as f:
        raw = json.load(f)
    return [RegimentInput(**item) for item in raw]


# return une liste de tout les medis presnet dans requete. l'url d'origne quelque soit
# le format de ficheir
def get_datas(ark_name: str, start: int, end: int, lot: int) -> list | None:
    base_api = "https://argonnaute.parisnanterre.fr/visualizer/api"
    params = {"arkName": ark_name, "start": start, "end": end, "group": lot}
    response = requests.get(base_api, params=params)
    result = []

    if response.status_code == 200:
        data = response.json()
        for item in data:
            loc = item.get("location", {}).get("original")
            if isinstance(loc, str):
                result.append(loc)
        return result

    return None


def fetch_medias(ark_name: str, nb_medias: int) -> List[str]:
    pdf = []
    pages = get_datas(ark_name=ark_name, start=0, end=nb_medias - 2, lot=0)
    if pages is not None:
        pdf = get_datas(ark_name=ark_name, start=0, end=0, lot=1)
    if pages is None:
        pages = get_datas(ark_name=ark_name, start=0, end=nb_medias - 2, lot=1)
        pdf = get_datas(ark_name=ark_name, start=0, end=nb_medias - 2, lot=0)
    return Medias(pages=pages, pdf=pdf[0] if pdf else None)


def main():
    # input_path = Path("regiments_list.json")
    # output_path = Path("regiments_complet.json")
    input_path = Path("regiments_list.json")
    output_path = Path("regiments_complet_medias.json")
    all_results: List[RegimentOutput] = []

    regiments_in = load_historique(input_path)

    for idx, regiment in enumerate(regiments_in, start=1):
        print(
            f"[{idx}/{len(regiments_in)}] Traite : {regiment.title} (ark_name={regiment.ark_name}, nb_medias={regiment.nb_medias})"
        )
        medias = fetch_medias(regiment.ark_name, regiment.nb_medias)
        # print(medias)

        all_results.append(
            RegimentOutput(
                title=regiment.title,
                ark_name=regiment.ark_name,
                nb_medias=regiment.nb_medias,
                medias=medias,
            )
        )

    with output_path.open("w", encoding="utf-8") as f:
        json.dump([asdict(r) for r in all_results], f, ensure_ascii=False, indent=2)


if __name__ == "__main__":
    main()
