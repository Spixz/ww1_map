from pydantic import BaseModel, Field


class CapitalOutput(BaseModel):
    capital: str = Field(description="The capital of the country.")


#  ? ecrire le docstring: What the tool does. When to use it. What arguments it requires (city: str). What information it returns.
def get_capital_city(country: str) -> str:
    """Retrieves the current weather report for a specified city.

    Args:
        city (str): The name of the city (e.g., "New York", "London", "Tokyo").

    Returns:
        dict: A dictionary containing the weather information.
              Includes a 'status' key ('success' or 'error').
              If 'success', includes a 'report' key with weather details.
              If 'error', includes an 'error_message' key.
    """
    capitals = {"france": "Paris", "japan": "Tokyo", "canada": "Ottawa"}
    return capitals.get(
        country.lower(), f"Sorry, I don't know the capital of {country}."
    )
