import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/left_pane/providers/map_controller_notifier.dart';
import 'package:ww1_map/features/map/providers/events_on_map_provider.dart';
import 'package:ww1_map/features/map/providers/selected_event_provider.dart';
import 'package:ww1_map/shared/data/mappers/gps_coordinates_mapper.dart';

final moveMapOnSelectedEventProvider = Provider((ref) {
  final selectedEvent = ref.watch(selectedEventProvider);
  final eventsOnMap = ref.read(eventsOnMapProvider);
  
  final eventToDisplay = eventsOnMap.firstWhereOrNull(
    (event) => event.title == selectedEvent?.title,
  );

  if (eventToDisplay != null && eventToDisplay.coordinatesForMap != null) {
    ref
        .read(mapControllerProvider.notifier)
        .get
        ?.move(eventToDisplay.coordinatesForMap!.toLatLng, 14);
  }
});
