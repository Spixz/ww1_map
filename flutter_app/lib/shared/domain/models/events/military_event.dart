import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:ww1_map/shared/domain/enums/event_kind.dart';
import 'package:ww1_map/shared/domain/mappers/dynamic_to_datetime.dart';
import 'package:ww1_map/shared/domain/mappers/object_id_from_json.dart';
import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';
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

  MilitaryEvent copyWith({
    ObjectId? id,
    ObjectId? regimentId,
    EventKind? eventKind,
    String? title,
    String? description,
    String? documentSource,
    int? documentSourcePage,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    String? engagementType,
    String? commander,
    String? executionUnit,
    String? order,
    String? target,
    String? outcome,
    List<WarEventCoordinates>? coordinates,
    GpsCoordinates? coordinatesForMap,
  }) {
    return MilitaryEvent(
      id: id ?? this.id,
      regimentId: regimentId ?? this.regimentId,
      eventKind: eventKind ?? this.eventKind,
      title: title ?? this.title,
      description: description ?? this.description,
      documentSource: documentSource ?? this.documentSource,
      documentSourcePage: documentSourcePage ?? this.documentSourcePage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      engagementType: engagementType ?? this.engagementType,
      commander: commander ?? this.commander,
      executionUnit: executionUnit ?? this.executionUnit,
      order: order ?? this.order,
      target: target ?? this.target,
      outcome: outcome ?? this.outcome,
      coordinates: coordinates ?? this.coordinates,
      coordinatesForMap: coordinatesForMap ?? this.coordinatesForMap,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$MilitaryEventToJson(this);

  @override
  String toString() => toJson().toString();
}
