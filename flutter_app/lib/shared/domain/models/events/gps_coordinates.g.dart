// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_coordinates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GpsCoordinates _$GpsCoordinatesFromJson(Map<String, dynamic> json) =>
    GpsCoordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GpsCoordinatesToJson(GpsCoordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
