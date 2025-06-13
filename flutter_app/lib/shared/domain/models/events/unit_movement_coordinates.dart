// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';

part 'unit_movement_coordinates.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UnitMovementCoordinates {
  UnitMovementCoordinates({
    required this.departurePoint,
    required this.arrivalPoint,
  });

  final List<GpsCoordinates> departurePoint;
  final List<GpsCoordinates> arrivalPoint;

  factory UnitMovementCoordinates.fromJson(Map<String, dynamic> json) =>
      _$UnitMovementCoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$UnitMovementCoordinatesToJson(this);
}
