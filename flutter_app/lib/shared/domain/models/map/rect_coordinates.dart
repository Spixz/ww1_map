import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';

class RectCoordinates {
  RectCoordinates({required this.bottomLeft, required this.topRight});

  RectCoordinates.empty()
    : bottomLeft = GpsCoordinates.empty(),
      topRight = GpsCoordinates.empty();

  final GpsCoordinates bottomLeft;
  final GpsCoordinates topRight;

  bool contain(GpsCoordinates point) {
    final minLat = bottomLeft.latitude;
    final maxLat = topRight.latitude;
    final minLng = bottomLeft.longitude;
    final maxLng = topRight.longitude;

    return point.latitude >= minLat &&
        point.latitude <= maxLat &&
        point.longitude >= minLng &&
        point.longitude <= maxLng;
  }

  @override
  String toString() => "bottomLeft: $bottomLeft / topRight: $topRight";
}
