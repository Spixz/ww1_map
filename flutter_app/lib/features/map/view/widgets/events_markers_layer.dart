import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:ww1_map/features/map/providers/map_events_provider.dart';
import 'package:ww1_map/features/map/providers/selected_event_provider.dart';
import 'package:ww1_map/shared/domain/enums/event_kind.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';

class EventsMarkersLayer extends ConsumerStatefulWidget {
  const EventsMarkersLayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EventsMarkersLayerState();
}

class _EventsMarkersLayerState extends ConsumerState<EventsMarkersLayer> {
  @override
  Widget build(BuildContext context) {
    final events = ref.watch(mapEventProvider);

    final markers =
        events
            .where((event) => event.coordinatesForMap != null)
            .map(_generateMarker)
            .toList();

    return MarkerLayer(markers: markers);
  }

  Marker _generateMarker(WarEvent event) {
    return Marker(
      point: LatLng(
        event.coordinatesForMap!.latitude,
        event.coordinatesForMap!.longitude,
      ),
      width: 40,
      height: 40,
      child: Tooltip(
        message: event.title,
        preferBelow: false,
        child: GestureDetector(
          onTap: () {
            print('Tapped on: ${event.title}');
            ref.read(selectedEventProvider.notifier).set(event);
          },
          child: _buildIcon(event.eventKind),
        ),
      ),
    );
  }

  Widget _buildIcon(EventKind eventType) {
    switch (eventType) {
      case EventKind.military:
        return const Icon(Icons.shield, color: Colors.red);
      case EventKind.unitMovement:
        return const Icon(Icons.directions_walk, color: Colors.blue);
      default:
        return const Icon(Icons.location_on, color: Colors.grey);
    }
  }
}
