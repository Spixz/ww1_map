import 'package:ww1_map/shared/domain/models/events/military_event.dart';
import 'package:ww1_map/shared/domain/models/events/unit_movement_event.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/shared/domain/models/events/war_event_coordinates.dart';

/// For each Unit movement or Military events, create a new instance
/// of the objet for each location inside the coordinates property,
/// associating the location to the coordinatesForMap property.
List<WarEvent> flatEventsLoc(List<WarEvent> events) {
  List<WarEvent> result = [];

  for (var index = 0; index < events.length; index++) {
    WarEvent event = events[index];

    if (event is MilitaryEvent) {
      if (event.coordinates == null) continue;

      final militaryEventCopies =
          event.coordinates!.map<MilitaryEvent>((
            WarEventCoordinates coordinates,
          ) {
            return event.copyWith(coordinatesForMap: coordinates.coordinates);
          }).toList();
      result += militaryEventCopies;
    }

    if (event is UnitMovementEvent) {
      if (event.coordinates == null) continue;

      if (event.coordinates?.departurePoint != null) {
        final movementDepartureCopies =
            event.coordinates!.departurePoint.map<UnitMovementEvent>((
              WarEventCoordinates coordinates,
            ) {
              return event.copyWith(coordinatesForMap: coordinates.coordinates);
            }).toList();
        result += movementDepartureCopies;
      }
      if (event.coordinates?.arrivalPoint != null) {
        final movementArrivalCopies =
            event.coordinates!.arrivalPoint.map<UnitMovementEvent>((
              WarEventCoordinates coordinates,
            ) {
              return event.copyWith(coordinatesForMap: coordinates.coordinates);
            }).toList();
        result += movementArrivalCopies;
      }
    }
  }

  return result;
}
