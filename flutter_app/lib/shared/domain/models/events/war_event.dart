// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/domain/enums/event_kind.dart';
import 'package:ww1_map/shared/domain/mappers/object_id_from_json.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:ww1_map/shared/domain/models/events/military_event.dart';
import 'package:ww1_map/shared/domain/models/events/political_event.dart';
import 'package:ww1_map/shared/domain/models/events/unit_movement_event.dart';

part 'war_event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WarEvent {
  WarEvent({
    this.id,
    required this.regimentId,
    required this.eventKind,
    required this.title,
    required this.description,
    required this.documentSource,
    required this.documentSourcePage,
    this.startDate,
    this.endDate,
  });

  @JsonKey(name: "_id", fromJson: objectIdFromJson)
  final ObjectId? id;
  @JsonKey(fromJson: objectIdFromJson)
  final ObjectId regimentId;

  @JsonKey(fromJson: EventKind.fromJson)
  final EventKind eventKind;
  final String title;
  final String description;
  final String documentSource;
  final int documentSourcePage;

  final DateTime? startDate;
  final DateTime? endDate;

  factory WarEvent.fromJson(Map<String, dynamic> json) =>
      _$WarEventFromJson(json);

  factory WarEvent.fromJsonBuilder(Map<String, dynamic> json) {
    final eventKind = EventKind.fromJson(json["event_kind"]);
    return switch (eventKind) {
      EventKind.political => PoliticalEvent.fromJson(json),
      EventKind.military => MilitaryEvent.fromJson(json),
      EventKind.unitMovement => UnitMovementEvent.fromJson(json),
      EventKind.other => WarEvent.fromJson(json)
    };
  }

  Map<String, dynamic> toJson() => _$WarEventToJson(this);
}
// {
// 	"event_kind": "Événement politique",
// 	"start_date", ("%Y-%m-%d %H:%M:%S")
// 	"end_date", ("%Y-%m-%d %H:%M:%S") (si applicable)
// 	"description", (String)
// 	"title", (String)
// 	"document_source", (String)
// 	"document_source_page" (int)
// }

// Les mouvements de troupes :
// {
// 	"event_kind": "Mouvement de troupes",
// 	"start_date", ("%Y-%m-%d %H:%M:%S")
// 	"end_date", (si applicable)
// 	"description", (String)
// 	"title", (String)
// 	"movement_type", (String)
// 	"executing_unit", (String)
// 	"departure_point", (String)
// 	"arrival_point", (String)
// 	"document_source", (String)
// 	"document_source_page" (int)
// }

// Les événements militaire:
// {
// 	"event_kind": "Événement militaire",
// 	"start_date", ("%Y-%m-%d %H:%M:%S")
// 	"end_date", (si applicable)
// 	"location", (String)
// 	"engagement_type", (String) (affrontement, fortification, ...)
// 	"commander", (String)
// 	"executing_unit", (String)
// 	"order", (String)
// 	"target", (String) (si applicable)
// 	"outcome", (String) (si applicable)
// 	"description", (String)
// 	"title", (String)
// 	"document_source", (String)
// 	"document_source_page" (int)
//  }
// """
