import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ww1_map/features/map/providers/map_informations_notifier.dart';
import 'package:ww1_map/shared/data/mappers/lat_lng_bounds_mapper.dart';
import 'package:ww1_map/shared/data/mappers/lat_lnt_mapper.dart';
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
          initialCenter: LatLng(48.866667, 2.373333),
          initialZoom: 12,
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
