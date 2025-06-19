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

  List<List<double>> toMongoBox() {
    final latitudes = [topLeft.latitude, bottomRight.latitude];
    final longitudes = [topLeft.longitude, bottomRight.longitude];

    final bottomLeft = GpsCoordinates(
      latitude: latitudes.reduce((a, b) => a < b ? a : b),
      longitude: longitudes.reduce((a, b) => a < b ? a : b),
    );

    final topRight = GpsCoordinates(
      latitude: latitudes.reduce((a, b) => a > b ? a : b),
      longitude: longitudes.reduce((a, b) => a > b ? a : b),
    );

    return [
      [bottomLeft.longitude, bottomLeft.latitude],
      [topRight.longitude, topRight.latitude],
    ];
  }

  @override
  String toString() => "topLeft: $topLeft / bottomRight: $bottomRight";
}
