import os
from dotenv import load_dotenv
from googlemaps import Client

load_dotenv()

_client: Client = None

def GoogleMapsClientInstance() -> Client:
    global _client
    if _client is None:
        _client = Client(key=os.getenv("GOOGLE_MAPS_API_KEY"))
    return _client
