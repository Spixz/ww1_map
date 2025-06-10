import requests
import os
from pathlib import Path
import uuid
from dotenv import load_dotenv

load_dotenv()

GOOGLE_MAPS_API_KEY = os.getenv("GOOGLE_MAPS_API_KEY")
STATIC_MAPS_URL = "https://maps.googleapis.com/maps/api/staticmap"

coordinates_to_image_declaration = {
    "name": "coordinate_to_image",
    "description": "Retourne une image de carte statique Google Maps à partir des coordonnées GPS fournies avec un marker représentant la localisation exacte.",
    "parameters": {
        "type": "object",
        "properties": {
            "latitude": {
                "type": "number",
                "description": "Latitude du point à afficher sur la carte, ex: 48.8584",
            },
            "longitude": {
                "type": "number",
                "description": "Longitude du point à afficher sur la carte, ex: 2.2945",
            },
            "zoom": {
                "type": "integer",
                "description": "Niveau de zoom de la carte (1 à 21), par défaut 15",
                "default": 15,
            },
        },
        "required": ["latitude", "longitude"],
    },
}

# 12 14 15
def get_static_map_image(latitude: float, longitude: float, zoom: int = 14) -> dict:
    """
    Récupère une image statique Google Maps pour un point donné.
    """
    params = {
        "center": f"{latitude},{longitude}",
        "zoom": zoom,
        "size": "600x400",
        "maptype": "roadmap",
        "markers": f"color:red|{latitude},{longitude}",
        "key": GOOGLE_MAPS_API_KEY,
    }

    response = requests.get(STATIC_MAPS_URL, params=params)
    if response.status_code != 200:
        raise Exception(f"Erreur API: {response.status_code}")

    filename = f"map_{uuid.uuid4().hex}.png"
    filepath = Path("maps") / filename
    filepath.parent.mkdir(parents=True, exist_ok=True)
    with open(filepath, "wb") as f:
        f.write(response.content)

    return {
        "image_path": str(filepath.resolve()),
        "latitude": latitude,
        "longitude": longitude,
        "zoom": zoom,
    }
