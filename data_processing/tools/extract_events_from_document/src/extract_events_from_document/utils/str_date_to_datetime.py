from datetime import datetime


def strDateToDatetime(date: str) -> datetime | None:
    for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d", "%Y-%m-%dT%H:%M:%S"):
        try:
            return datetime.strptime(date, fmt)
        except Exception:
            continue
    print(f"Date format invalid {date}")
    return None
