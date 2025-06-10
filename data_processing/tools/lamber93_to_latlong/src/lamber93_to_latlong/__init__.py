from pyproj import Transformer
import argparse

_transformer_2154_to_4326 = Transformer.from_crs(
    "EPSG:2154", "EPSG:4326", always_xy=True
)


def lambert93_to_latlon(x: float, y: float) -> tuple[float, float]:
    """
    Converts Lambert-93 (EPSG:2154) coordinates to latitude/longitude (EPSG:4326).
    (Used for locations originating from the French IGN General Staff map)

    Args:
        x (float): Easting coordinate (in meters)
        y (float): Northing coordinate (in meters)

    Returns:
        tuple: (latitude, longitude) in decimal degrees
    """
    lon, lat = _transformer_2154_to_4326.transform(x, y)
    return lat, lon


def main():
    parser = argparse.ArgumentParser(
        description="Convert Lambert-93 coordinates to latitude/longitude."
    )
    parser.add_argument(
        "x", type=float, help="Easting coordinate (X) in Lambert-93 (meters)"
    )
    parser.add_argument(
        "y", type=float, help="Northing coordinate (Y) in Lambert-93 (meters)"
    )
    args = parser.parse_args()

    lat, lon = lambert93_to_latlon(args.x, args.y)
    print("Latitude, Longitude")
    print(f"{lat}, {lon}")