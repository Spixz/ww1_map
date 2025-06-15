import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ww1_map/features/map/providers/map_informations_notifier.dart';
import 'package:ww1_map/shared/data/mappers/lat_lng_bounds_mapper.dart';
import 'package:ww1_map/shared/data/mappers/lat_lnt_mapper.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController mapController = MapController();

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(48.866667, 2.373333),
          initialZoom: 12,
          onMapReady: () {},
          onPositionChanged: _onPositionChanged,
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

  void _onPositionChanged(MapCamera camera, bool hasGestue) {
    ref
        .read(mapInformationsProvider.notifier)
        .update(
          center: camera.center.toGpsCoordinates,
          bounds: camera.visibleBounds.toRectCoordinates,
        );
  }
}
