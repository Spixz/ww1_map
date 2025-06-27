// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ww1_map/shared/domain/enums/event_kind.dart';
import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';

part 'war_event_original.freezed.dart';
part 'war_event_original.g.dart';

@freezed
class WarEventOriginal with _$WarEventOriginal {
  factory WarEventOriginal({
    final String? id,
    required final String regimentId,
    required final EventKind eventKind,
    required final String title,
    required final String description,
    required final String documentSource,
    required final int documentSourcePage,
    final DateTime? startDate,
    final DateTime? endDate,
    GpsCoordinates? coordinatesForMap,
  }) = _WarEventOriginal;

  factory WarEventOriginal.fromJson(Map<String, dynamic> json) =>
      _$WarEventOriginalFromJson(json);
}
