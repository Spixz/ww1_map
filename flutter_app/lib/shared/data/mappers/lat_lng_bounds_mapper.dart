import 'package:flutter_map/flutter_map.dart';

import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';
import 'package:ww1_map/shared/domain/models/map/rect_coordinates.dart';

extension LatLngBoundsExtension on LatLngBounds {
  RectCoordinates get toRectCoordinates => RectCoordinates(
    topLeft: GpsCoordinates(latitude: north, longitude: west),
    bottomRight: GpsCoordinates(latitude: south, longitude: east),
  );
}
