// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'war_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarEvent _$WarEventFromJson(Map<String, dynamic> json) => WarEvent(
  id: objectIdFromJson(json['_id'] as ObjectId),
  regimentId: objectIdFromJson(json['regiment_id'] as ObjectId),
  eventKind: EventKind.fromJson(json['event_kind'] as String),
  title: json['title'] as String,
  description: json['description'] as String,
  documentSource: json['document_source'] as String,
  documentSourcePage: (json['document_source_page'] as num).toInt(),
  startDate:
      json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
  endDate:
      json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
);

Map<String, dynamic> _$WarEventToJson(WarEvent instance) => <String, dynamic>{
  '_id': instance.id,
  'regiment_id': instance.regimentId,
  'event_kind': _$EventKindEnumMap[instance.eventKind]!,
  'title': instance.title,
  'description': instance.description,
  'document_source': instance.documentSource,
  'document_source_page': instance.documentSourcePage,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
};

const _$EventKindEnumMap = {
  EventKind.political: 'political',
  EventKind.military: 'military',
  EventKind.unitMovement: 'unitMovement',
  EventKind.other: 'other',
};
