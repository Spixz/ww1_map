import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/map/providers/map_informations_notifier.dart';
import 'package:ww1_map/features/right_pane/providers/events_notifier.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/shared/domain/utils/flat_war_events.dart';

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
