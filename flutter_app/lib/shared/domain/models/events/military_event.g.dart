// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'military_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MilitaryEvent _$MilitaryEventFromJson(Map<String, dynamic> json) =>
    MilitaryEvent(
      regimentId: objectIdFromJson(json['regiment_id'] as ObjectId),
      eventKind: EventKind.fromJson(json['event_kind'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      documentSource: json['document_source'] as String,
      documentSourcePage: (json['document_source_page'] as num).toInt(),
      location: json['location'] as String?,
      engagementType: json['engagement_type'] as String?,
      commander: json['commander'] as String?,
      executionUnit: json['execution_unit'] as String?,
      order: json['order'] as String?,
      target: json['target'] as String?,
      outcome: json['outcome'] as String?,
      coordinates:
          (json['coordinates'] as List<dynamic>?)
              ?.map(
                (e) => WarEventCoordinates.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );

Map<String, dynamic> _$MilitaryEventToJson(MilitaryEvent instance) =>
    <String, dynamic>{
      'regiment_id': instance.regimentId,
      'event_kind': _$EventKindEnumMap[instance.eventKind]!,
      'title': instance.title,
      'description': instance.description,
      'document_source': instance.documentSource,
      'document_source_page': instance.documentSourcePage,
      'location': instance.location,
      'engagement_type': instance.engagementType,
      'commander': instance.commander,
      'execution_unit': instance.executionUnit,
      'order': instance.order,
      'target': instance.target,
      'outcome': instance.outcome,
      'coordinates': instance.coordinates,
    };

const _$EventKindEnumMap = {
  EventKind.political: 'political',
  EventKind.military: 'military',
  EventKind.unitMovement: 'unitMovement',
  EventKind.other: 'other',
};
