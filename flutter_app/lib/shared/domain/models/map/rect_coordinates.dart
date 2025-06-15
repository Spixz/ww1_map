import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';

class RectCoordinates {
  RectCoordinates({required this.topLeft, required this.bottomRight});

  RectCoordinates.empty()
    : topLeft = GpsCoordinates.empty(),
      bottomRight = GpsCoordinates.empty();

  final GpsCoordinates topLeft;
  final GpsCoordinates bottomRight;
}
