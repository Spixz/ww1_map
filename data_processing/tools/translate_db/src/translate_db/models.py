# models.py
from pydantic import BaseModel, Field
from typing import List, Optional, Literal, Union, Any
from datetime import datetime

# --- Modèles de base pour les données non textuelles ---

class GeoPoint(BaseModel):
    type: Literal["Point"]
    coordinates: List[float]  # [longitude, latitude]

class NamedLocation(BaseModel):
    name: str
    coordinates: GeoPoint

class TroopMovementCoordinates(BaseModel):
    departure_point: List[NamedLocation]
    arrival_point: List[NamedLocation]
    
class Media(BaseModel):
    pages: List[str]
    pdf: Optional[str] = None

# --- Modèles complets pour les collections ---
# Ces modèles représentent la structure FINALE des documents dans la nouvelle base de données.
# Ils incluent TOUS les champs, traduits ou non.

class RegimentDocument(BaseModel):
    """
    Représente la structure complète d'un document de la collection 'regiments'.
    Les champs 'title' et 'description' seront traduits.
    """
    id: Any = Field(alias="_id") # Utilise un alias pour le champ _id de MongoDB
    title: str
    ark_name: str
    nb_medias: int
    medias: Media
    description: Optional[str] = None

class BaseEvent(BaseModel):
    """Structure de base partagée par tous les événements."""
    id: Any = Field(alias="_id")
    event_kind: str  # Ce champ ne sera PAS traduit.
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    title: str
    description: str
    document_source: str
    document_source_page: int
    regiment_id: Any # Peut être un ObjectId, donc 'Any' est sûr

class TroopMovementEvent(BaseEvent):
    """Structure complète d'un événement 'Troop movement'."""
    event_kind: Literal["Troop movement"]
    movement_type: str
    executing_unit: Optional[str] = None
    departure_point: Optional[str] = None
    arrival_point: Optional[str] = None
    coordinates: Optional[TroopMovementCoordinates] = None

class MilitaryEvent(BaseEvent):
    """Structure complète d'un événement 'Military event'."""
    event_kind: Literal["Military event"]
    location: Optional[str] = None
    engagement_type: Optional[str] = None
    order: Optional[str] = None
    target: Optional[str] = None
    executing_unit: Optional[str] = None
    coordinates: Optional[List[NamedLocation]] = None

class PoliticalEvent(BaseEvent):
    """Structure complète d'un événement 'Political event'."""
    event_kind: Literal["Political event"]
    # Pas de champs additionnels par rapport à BaseEvent, mais listé pour la clarté.


# --- Modèles pour la TRADUCTION (ce qui est envoyé à l'API) ---
# Ces modèles ne contiennent QUE les champs textuels à traduire.
# C'est une optimisation pour réduire les coûts et éviter les erreurs.

class RegimentForTranslation(BaseModel):
    title: str = Field(description="The translated title of the regiment.")
    description: Optional[str] = Field(description="The translated description of the regiment, can be null.")

class TroopMovementForTranslation(BaseModel):
    movement_type: Optional[str] = Field(description="Translated type of movement (e.g., 'March', 'Deployment').")
    executing_unit: Optional[str] = Field(description="Name of the executing unit, translated if it's a generic term.")
    departure_point: Optional[str] = Field(description="Translated name of the departure location.")
    arrival_point: Optional[str] = Field(description="Translated name of the arrival location.")
    description: str = Field(description="Translated detailed description of the event.")
    title: str = Field(description="Translated concise title of the event.")

class MilitaryEventForTranslation(BaseModel):
    location: Optional[str] = Field(description="Translated name of the event location.")
    engagement_type: Optional[str] = Field(description="Translated type of engagement (e.g., 'Battle', 'Skirmish').")
    order: Optional[str] = Field(description="Translated order given.")
    target: Optional[str] = Field(description="Translated target of the military action.")
    executing_unit: Optional[str] = Field(description="Name of the executing unit, translated if it's a generic term.")
    description: str = Field(description="Translated detailed description of the event.")
    title: str = Field(description="Translated concise title of the event.")

class PoliticalEventForTranslation(BaseModel):
    description: str = Field(description="Translated detailed description of the event.")
    title: str = Field(description="Translated concise title of the event.")