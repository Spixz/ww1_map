from google.adk.tools import ToolContext


def set_extracted_events(events: list[dict], tool_context: ToolContext) -> str:
    """Stock dans les événements dans extracted_events en supprimant les événements précédants

    Args:
        event: (str): Les événements à stocker sous forme de liste

    Returns:
        En cas de succès return "Stockage dans extracted_events réussi."
        En cas d'erreur return "Stockage dans extracted_events échoué."
    """
    try:
        print("isndide set_extracted_events tool")
        tool_context.state["extracted_events"] = events
        return "Stockage dans extracted_events réussi."
    except Exception:
        return "Stockage dans extracted_events échoué."


def get_extracted_events(tool_context: ToolContext) -> list[dict]:
    """Retourne la liste des événements contenu dans extracted_events."""
    return tool_context.state["extracted_events"]
