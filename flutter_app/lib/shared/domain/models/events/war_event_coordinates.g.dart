// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'war_event_coordinates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarEventCoordinates _$WarEventCoordinatesFromJson(Map<String, dynamic> json) =>
    WarEventCoordinates(
      name: json['name'] as String,
      coordinates: GpsCoordinates.fromJson(
        json['coordinates'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$WarEventCoordinatesToJson(
  WarEventCoordinates instance,
) => <String, dynamic>{
  'name': instance.name,
  'coordinates': instance.coordinates,
};
