from common import GoogleMapsClientInstance


def get_places_gps_coordinates(place: str):
    """Fait un call à l'api de géocodage de google afin de récupérer les coordonnés gps d'un lieu.

    Args:
        place: Le nom du lieu à rechercher

    Returns:
       Une string contenant l'objet suivant:
       "{
            "results": [                // Liste des résultats correspondants à la requête
                {
                "address_components": [ // Composants de l'adresse, du plus précis au plus large
                    {
                    "long_name": "...",   // Nom complet (ex: "Versailles")
                    "short_name": "...",  // Nom abrégé (ex: "FR" pour France)
                    "types": [...]        // Types de composant (ex: "country", "locality")
                    },
                    ...
                ],
                "formatted_address": "...", // Adresse complète sous forme lisible (ex: "78000 Versailles, France")
                "geometry": {
                    "bounds": {             // Limites géographiques de la zone (bounding box)
                    "northeast": { "lat": ..., "lng": ... },
                    "southwest": { "lat": ..., "lng": ... }
                    },
                    "location": {           // Coordonnées GPS principales (latitude, longitude)
                    "lat": ...,
                    "lng": ...
                    },
                    "location_type": "...", // Précision de la localisation (ex: "APPROXIMATE")
                    "viewport": {           // Zone à afficher sur une carte pour englober l'endroit
                    "northeast": { "lat": ..., "lng": ... },
                    "southwest": { "lat": ..., "lng": ... }
                    }
                },
                "place_id": "...",         // Identifiant unique Google du lieu
                "types": [ ... ]           // Types de lieu (ex: "locality", "political")
                }
            ],
            "status": "OK"                // Statut de la requête ("OK" si succès)
            }"
    """
    client = GoogleMapsClientInstance()
    return client.geocode(place)
