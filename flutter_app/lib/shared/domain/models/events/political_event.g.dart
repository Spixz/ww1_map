// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'political_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoliticalEvent _$PoliticalEventFromJson(Map<String, dynamic> json) =>
    PoliticalEvent(
        id: objectIdFromJson(json['_id'] as ObjectId),
        regimentId: objectIdFromJson(json['regiment_id'] as ObjectId),
        eventKind: EventKind.fromJson(json['event_kind'] as String),
        title: json['title'] as String,
        description: json['description'] as String,
        documentSource: json['document_source'] as String,
        documentSourcePage: (json['document_source_page'] as num).toInt(),
        startDate: dynamicToDateTime(json['start_date']),
        endDate: dynamicToDateTime(json['end_date']),
      )
      ..coordinatesForMap =
          json['coordinates_for_map'] == null
              ? null
              : GpsCoordinates.fromJson(
                json['coordinates_for_map'] as Map<String, dynamic>,
              );

Map<String, dynamic> _$PoliticalEventToJson(PoliticalEvent instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'regiment_id': instance.regimentId,
      'event_kind': _$EventKindEnumMap[instance.eventKind]!,
      'title': instance.title,
      'description': instance.description,
      'document_source': instance.documentSource,
      'document_source_page': instance.documentSourcePage,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'coordinates_for_map': instance.coordinatesForMap,
    };

const _$EventKindEnumMap = {
  EventKind.political: 'political',
  EventKind.military: 'military',
  EventKind.unitMovement: 'unitMovement',
  EventKind.other: 'other',
};
