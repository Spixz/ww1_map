import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ww1_map/features/map/providers/map_events_provider.dart';
import 'package:ww1_map/features/map/providers/map_informations_notifier.dart';
import 'package:ww1_map/features/map/providers/selected_event_provider.dart';
import 'package:ww1_map/shared/data/mappers/gps_coordinates_mapper.dart';
import 'package:ww1_map/shared/data/mappers/lat_lng_bounds_mapper.dart';
import 'package:ww1_map/shared/data/mappers/lat_lnt_mapper.dart';
import 'package:ww1_map/shared/domain/enums/event_kind.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/utils/debouncer.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController mapController = MapController();
  late StreamSubscription<MapEvent> mapEventsSubscription;
  final Debouncer debouncer = Debouncer(delay: Duration(milliseconds: 500));

  @override
  void dispose() {
    mapEventsSubscription.cancel();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(46.866667, 2.973333),
          initialZoom: 6,
          onMapReady: () {
            mapEventsSubscription = mapController.mapEventStream.listen((
              event,
            ) {
              if (event is MapEventMoveEnd) _updateMapInformation();
              if (event is MapEventScrollWheelZoom) _updateMapInformation();
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'cyril.ww1_map',
          ),
          RichAttributionWidget(
            alignment: AttributionAlignment.bottomLeft,
            popupInitialDisplayDuration: Duration(seconds: 2),
            showFlutterMapAttribution: false,
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap:
                    () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright'),
                    ),
              ),
            ],
          ),
          EventsMarkersLayer(mapController),
        ],
      ),
    );
  }

  void _updateMapInformation() {
    debouncer.call(
      () => ref
          .read(mapInformationsProvider.notifier)
          .update(
            center: mapController.camera.center.toGpsCoordinates,
            bounds: mapController.camera.visibleBounds.toRectCoordinates,
          ),
    );
  }
}

class EventsMarkersLayer extends ConsumerWidget {
  const EventsMarkersLayer(this.mapController, {super.key});
  final MapController mapController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(mapEventProvider);
    ref.listen(selectedEventProvider, (prev, next) {
      if (prev != next) {
        final eventToDisplay = events.firstWhereOrNull(
          (event) => next?.title == event.title,
        );
        if (eventToDisplay != null &&
            eventToDisplay.coordinatesForMap != null) {
          mapController.move(eventToDisplay.coordinatesForMap!.toLatLng, 15);
        }
      }
    });
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
