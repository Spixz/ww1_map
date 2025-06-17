import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/map/providers/map_informations_notifier.dart';
import 'package:ww1_map/features/right_pane/providers/events_notifier.dart';
import 'package:ww1_map/shared/domain/models/events/military_event.dart';
import 'package:ww1_map/shared/domain/models/events/unit_movement_event.dart';

import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/shared/domain/models/events/war_event_coordinates.dart';

final mapEventProvider = Provider<List<WarEvent>>((ref) {
  final eventsMode = ref.watch(eventsListModeProvider);
  final eventProvider = ref.watch(eventsProvider);
  final events = eventProvider.value ?? [];

  if (eventsMode == EventsListMode.free) return flatEventsLoc(events);

  final mapInfos = ref.watch(mapInformationsProvider);
  final duplicatedEvents = flatEventsLoc(events);
  final eventInsideMapArea = duplicatedEvents.where(
    (event) =>
        event.coordinatesForMap != null &&
        mapInfos.bounds.contain(event.coordinatesForMap!),
  );

  return eventInsideMapArea.toList();
});

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
