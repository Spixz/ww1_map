import 'package:latlong2/latlong.dart';

import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';

extension LatLngExtension on LatLng {
  GpsCoordinates get toGpsCoordinates =>
      GpsCoordinates(latitude: latitude, longitude: longitude);
}
