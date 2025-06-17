import 'package:latlong2/latlong.dart';

import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';

extension GpsCoordinatesExtension on GpsCoordinates {
  LatLng get toLatLng => LatLng(latitude, longitude);
}
