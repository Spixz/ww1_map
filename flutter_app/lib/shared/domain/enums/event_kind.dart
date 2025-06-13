enum EventKind {
  political,
  military,
  unitMovement,
  other;

  static EventKind fromJson(String value) => switch (value) {
    "Événement politique" => EventKind.political,
    "Événement militaire" => EventKind.military,
    "Mouvement de troupes" => EventKind.unitMovement,
    _ => EventKind.other,
  };
}
