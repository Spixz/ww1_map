import 'package:json_annotation/json_annotation.dart';

part 'gps_coordinates.g.dart';

@JsonSerializable()
class GpsCoordinates {
  final double latitude;
  final double longitude;

  GpsCoordinates({required this.latitude, required this.longitude});

  factory GpsCoordinates.fromJson(Map<String, dynamic> json) {
    final coords =
        (json['coordinates']['coordinates'] as List<dynamic>)
            .whereType<double>()
            .toList();
    return GpsCoordinates(
      longitude: (coords[0] as num).toDouble(),
      latitude: (coords[1] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => _$GpsCoordinatesToJson(this);
}
