// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';
import 'package:ww1_map/shared/domain/models/map/rect_coordinates.dart';

class MapInformations {
  MapInformations({required this.center, required this.bounds});

  final GpsCoordinates center;
  final RectCoordinates bounds;

  MapInformations copyWith({
    GpsCoordinates? center,
    RectCoordinates? bounds,
  }) {
    return MapInformations(
      center: center ?? this.center,
      bounds: bounds ?? this.bounds,
    );
  }
}

class EmptyMapInformations extends MapInformations {
  EmptyMapInformations()
    : super(center: GpsCoordinates.empty(), bounds: RectCoordinates.empty());
}
