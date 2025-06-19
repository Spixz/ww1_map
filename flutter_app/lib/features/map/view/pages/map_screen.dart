import 'dart:async';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ww1_map/features/left_pane/providers/map_controller_notifier.dart';
import 'package:ww1_map/features/map/providers/move_map_on_selected_event_provider.dart';

import 'package:ww1_map/features/map/providers/map_informations_notifier.dart';
import 'package:ww1_map/features/map/view/widgets/events_markers_layer.dart';
import 'package:ww1_map/shared/data/mappers/lat_lng_bounds_mapper.dart';
import 'package:ww1_map/shared/data/mappers/lat_lnt_mapper.dart';
import 'package:ww1_map/utils/debouncer.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late StreamSubscription<MapEvent> mapEventsSubscription;
  final Debouncer debouncer = Debouncer(delay: Duration(milliseconds: 500));

  @override
  void dispose() {
    mapEventsSubscription.cancel();
    ref.read(mapControllerProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapController = ref.watch(mapControllerProvider);
    ref.watch(moveMapOnSelectedEventProvider);

    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(46.866667, 2.973333),
          initialZoom: 6,
          onMapReady: () {
            ref.read(mapControllerProvider.notifier).declareReady();
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
          const EventsMarkersLayer(),
        ],
      ),
    );
  }

  void _updateMapInformation() {
    debouncer.call(() {
      final mapController = ref.read(mapControllerProvider);
      ref
          .read(mapInformationsProvider.notifier)
          .update(
            center: mapController.camera.center.toGpsCoordinates,
            bounds: mapController.camera.visibleBounds.toRectCoordinates,
          );
    });
  }
}
