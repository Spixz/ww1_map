import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:ww1_map/shared/domain/enums/event_kind.dart';
import 'package:ww1_map/shared/domain/utils/dynamic_to_datetime.dart';
import 'package:ww1_map/shared/domain/mappers/object_id_from_json.dart';
import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';

part 'political_event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PoliticalEvent extends WarEvent {
  PoliticalEvent({
    required super.id,
    required super.regimentId,
    required super.eventKind,
    required super.title,
    required super.description,
    required super.documentSource,
    required super.documentSourcePage,
    super.startDate,
    super.endDate,
  });

  factory PoliticalEvent.fromJson(Map<String, dynamic> json) =>
      _$PoliticalEventFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PoliticalEventToJson(this);
}
