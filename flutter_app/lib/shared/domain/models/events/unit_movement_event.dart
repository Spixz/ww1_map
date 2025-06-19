import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:ww1_map/shared/domain/enums/event_kind.dart';
import 'package:ww1_map/shared/domain/utils/dynamic_to_datetime.dart';
import 'package:ww1_map/shared/domain/mappers/object_id_from_json.dart';
import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';
import 'package:ww1_map/shared/domain/models/events/unit_movement_coordinates.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';

part 'unit_movement_event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UnitMovementEvent extends WarEvent {
  UnitMovementEvent({
    required super.id,
    required super.regimentId,
    required super.eventKind,
    required super.title,
    required super.description,
    required super.documentSource,
    required super.documentSourcePage,
    super.startDate,
    super.endDate,
    super.coordinatesForMap,
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

  UnitMovementEvent copyWith({
    ObjectId? id,
    ObjectId? regimentId,
    EventKind? eventKind,
    String? title,
    String? description,
    String? documentSource,
    int? documentSourcePage,
    DateTime? startDate,
    DateTime? endDate,
    String? movementType,
    String? executingUnit,
    String? departurePoint,
    String? arrivalPoint,
    UnitMovementCoordinates? coordinates,
    GpsCoordinates? coordinatesForMap,
  }) {
    return UnitMovementEvent(
      id: id ?? this.id,
      regimentId: regimentId ?? this.regimentId,
      eventKind: eventKind ?? this.eventKind,
      title: title ?? this.title,
      description: description ?? this.description,
      documentSource: documentSource ?? this.documentSource,
      documentSourcePage: documentSourcePage ?? this.documentSourcePage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      movementType: movementType ?? this.movementType,
      executingUnit: executingUnit ?? this.executingUnit,
      departurePoint: departurePoint ?? this.departurePoint,
      arrivalPoint: arrivalPoint ?? this.arrivalPoint,
      coordinates: coordinates ?? this.coordinates,
      coordinatesForMap: coordinatesForMap ?? this.coordinatesForMap,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$UnitMovementEventToJson(this);

  @override
  String toString() => toJson().toString();
}
