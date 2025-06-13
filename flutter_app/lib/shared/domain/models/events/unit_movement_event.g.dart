// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_movement_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitMovementEvent _$UnitMovementEventFromJson(Map<String, dynamic> json) =>
    UnitMovementEvent(
      regimentId: objectIdFromJson(json['regiment_id'] as ObjectId),
      eventKind: EventKind.fromJson(json['event_kind'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      documentSource: json['document_source'] as String,
      documentSourcePage: (json['document_source_page'] as num).toInt(),
      movementType: json['movement_type'] as String?,
      executingUnit: json['executing_unit'] as String?,
      departurePoint: json['departure_point'] as String?,
      arrivalPoint: json['arrival_point'] as String?,
      coordinates:
          json['coordinates'] == null
              ? null
              : UnitMovementCoordinates.fromJson(
                json['coordinates'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$UnitMovementEventToJson(UnitMovementEvent instance) =>
    <String, dynamic>{
      'regiment_id': instance.regimentId,
      'event_kind': _$EventKindEnumMap[instance.eventKind]!,
      'title': instance.title,
      'description': instance.description,
      'document_source': instance.documentSource,
      'document_source_page': instance.documentSourcePage,
      'movement_type': instance.movementType,
      'executing_unit': instance.executingUnit,
      'departure_point': instance.departurePoint,
      'arrival_point': instance.arrivalPoint,
      'coordinates': instance.coordinates,
    };

const _$EventKindEnumMap = {
  EventKind.political: 'political',
  EventKind.military: 'military',
  EventKind.unitMovement: 'unitMovement',
  EventKind.other: 'other',
};
