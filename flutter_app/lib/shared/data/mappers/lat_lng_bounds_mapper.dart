import 'package:flutter_map/flutter_map.dart';

import 'package:ww1_map/shared/data/mappers/lat_lnt_mapper.dart';
import 'package:ww1_map/shared/domain/models/map/rect_coordinates.dart';

extension LatLngBoundsExtension on LatLngBounds {
  RectCoordinates get toRectCoordinates => RectCoordinates(
    bottomLeft: southWest.toGpsCoordinates,
    topRight: northEast.toGpsCoordinates,
  );
}
