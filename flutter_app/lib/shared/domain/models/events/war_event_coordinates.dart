import 'package:json_annotation/json_annotation.dart';
import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';

part 'war_event_coordinates.g.dart';

@JsonSerializable()
class WarEventCoordinates {
  final String name;
  final GpsCoordinates coordinates;

  WarEventCoordinates({required this.name, required this.coordinates});

  factory WarEventCoordinates.fromJson(Map<String, dynamic> json) =>
      WarEventCoordinates(
        name: json["name"] as String,
        coordinates: GpsCoordinates.fromJson(
          json["coordinates"] as Map<String, dynamic>,
        ),
      );

  Map<String, dynamic> toJson() => _$WarEventCoordinatesToJson(this);
}
