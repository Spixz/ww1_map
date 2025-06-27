import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ww1_map/shared/domain/enums/event_kind.dart';
import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';
import 'package:ww1_map/shared/domain/models/events_original/war_event_original.dart';

part 'political_event_original.freezed.dart';
part 'political_event_original.g.dart';

@freezed
class PoliticalEventOriginal extends WarEventOriginal
    with _$PoliticalEventOriginal {
  const PoliticalEventOriginal._(
    super.id,
    super.regimentId,
    super.eventKind,
    super.title,
    super.description,
    super.documentSource,
    super.documentSourcePage,
    super.startDate,
    super.endDate,
  );

  factory PoliticalEventOriginal({
    id,
    regimentId,
    eventKind,
    title,
    description,
    documentSource,
    documentSourcePage,
    startDate,
    endDate,
    coordinatesForMap,
  }) = _PoliticalEventOriginal;

  factory PoliticalEventOriginal.fromJson(Map<String, dynamic> json) =>
      _$PoliticalEventOriginalFromJson(json);
}
