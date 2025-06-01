
from datetime import datetime

def str_date_to_datetime(date: str) -> datetime:
    """Convertis une date string utilisant le format **"%Y-%m-%d %H:%M:%S"** en une date de type datetime.

    Args:
        date (str): Date au format **"%Y-%m-%d %H:%M:%S"** (e.g 2025-05-30 14:32:00).
    
    Returns:
        Date au format datetime.
    """
    return datetime.strptime(date, "%Y-%m-%d %H:%M:%S")