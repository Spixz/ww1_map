// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_coordinates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GpsCoordinates _$GpsCoordinatesFromJson(Map<String, dynamic> json) =>
    GpsCoordinates(
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GpsCoordinatesToJson(GpsCoordinates instance) =>
    <String, dynamic>{
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
