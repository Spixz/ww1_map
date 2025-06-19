import 'package:ww1_map/shared/domain/models/map/rect_coordinates.dart';

extension RectCoordinatesExtension on RectCoordinates {
  List<List<double>> toMongoBox() {
    return [
      [bottomLeft.longitude, bottomLeft.latitude],
      [topRight.longitude, topRight.latitude],
    ];
  }
}