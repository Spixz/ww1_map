// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gps_coordinates_original.freezed.dart';
part 'gps_coordinates_original.g.dart';


@freezed
class GpsCoordinatesOriginal with _$GpsCoordinatesOriginal {
  const GpsCoordinatesOriginal._();

  factory GpsCoordinatesOriginal(
    {
      required final double longitude,
      required final double latitude,
    }
  ) = _GpsCoordinatesOriginal;

  List<double> get toList => [longitude, latitude];

  factory GpsCoordinatesOriginal.fromJson(Map<String, dynamic> json) => _$GpsCoordinatesOriginalFromJson(json);
}