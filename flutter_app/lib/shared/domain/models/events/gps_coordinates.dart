import 'package:json_annotation/json_annotation.dart';

part 'gps_coordinates.g.dart';

@JsonSerializable()
class GpsCoordinates {
  final double longitude;
  final double latitude;

  GpsCoordinates({required this.longitude, required this.latitude});

  GpsCoordinates.empty() : latitude = 0, longitude = 0;

  factory GpsCoordinates.fromJson(Map<String, dynamic> json) {
    final coords =
        (json['coordinates'] as List<dynamic>).whereType<double>().toList();
    return GpsCoordinates(
      longitude: (coords[0] as num).toDouble(),
      latitude: (coords[1] as num).toDouble(),
    );
  }

  List<double> get toList => [longitude, latitude];

  Map<String, dynamic> toJson() => _$GpsCoordinatesToJson(this);

  @override
  String toString() => toJson().toString();
}
