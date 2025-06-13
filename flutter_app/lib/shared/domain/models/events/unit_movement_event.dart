import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/domain/enums/event_kind.dart';
import 'package:ww1_map/shared/domain/mappers/object_id_from_json.dart';
import 'package:ww1_map/shared/domain/models/events/unit_movement_coordinates.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';

part 'unit_movement_event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UnitMovementEvent extends WarEvent {
  UnitMovementEvent({
    required super.regimentId,
    required super.eventKind,
    required super.title,
    required super.description,
    required super.documentSource,
    required super.documentSourcePage,
    this.movementType,
    this.executingUnit,
    this.departurePoint,
    this.arrivalPoint,
    this.coordinates,
  });

  final String? movementType;
  final String? executingUnit;
  final String? departurePoint;
  final String? arrivalPoint;
  final UnitMovementCoordinates? coordinates;

  factory UnitMovementEvent.fromJson(Map<String, dynamic> json) =>
      _$UnitMovementEventFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UnitMovementEventToJson(this);
}
