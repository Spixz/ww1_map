// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_movement_coordinates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitMovementCoordinates _$UnitMovementCoordinatesFromJson(
  Map<String, dynamic> json,
) => UnitMovementCoordinates(
  departurePoint:
      (json['departure_point'] as List<dynamic>)
          .map((e) => GpsCoordinates.fromJson(e as Map<String, dynamic>))
          .toList(),
  arrivalPoint:
      (json['arrival_point'] as List<dynamic>)
          .map((e) => GpsCoordinates.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$UnitMovementCoordinatesToJson(
  UnitMovementCoordinates instance,
) => <String, dynamic>{
  'departure_point': instance.departurePoint,
  'arrival_point': instance.arrivalPoint,
};
