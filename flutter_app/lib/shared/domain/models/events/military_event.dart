import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/domain/enums/event_kind.dart';
import 'package:ww1_map/shared/domain/mappers/object_id_from_json.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/shared/domain/models/events/war_event_coordinates.dart';

part 'military_event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MilitaryEvent extends WarEvent {
  final String? location;
  final String? engagementType;
  final String? commander;
  final String? executionUnit;
  final String? order;
  final String? target;
  final String? outcome;
  final List<WarEventCoordinates>? coordinates;

  MilitaryEvent({
    required super.regimentId,
    required super.eventKind,
    required super.title,
    required super.description,
    required super.documentSource,
    required super.documentSourcePage,
    this.location,
    this.engagementType,
    this.commander,
    this.executionUnit,
    this.order,
    this.target,
    this.outcome,
    this.coordinates,
  });

  factory MilitaryEvent.fromJson(Map<String, dynamic> json) =>
      _$MilitaryEventFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MilitaryEventToJson(this);
}
