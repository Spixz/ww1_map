import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';

class RectCoordinates {
  RectCoordinates({required this.topLeft, required this.bottomRight});

  RectCoordinates.empty()
    : topLeft = GpsCoordinates.empty(),
      bottomRight = GpsCoordinates.empty();

  final GpsCoordinates topLeft;
  final GpsCoordinates bottomRight;

  bool contain(GpsCoordinates point) {
    final minLat = bottomRight.latitude;
    final maxLat = topLeft.latitude;
    final minLng = topLeft.longitude;
    final maxLng = bottomRight.longitude;

    return point.latitude >= minLat &&
        point.latitude <= maxLat &&
        point.longitude >= minLng &&
        point.longitude <= maxLng;
  }

  @override
  String toString() => "topLeft: $topLeft / bottomRight: $bottomRight";
}
