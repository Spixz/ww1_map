// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'war_event_original.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarEventOriginalImpl _$$WarEventOriginalImplFromJson(
  Map<String, dynamic> json,
) => _$WarEventOriginalImpl(
  id: json['id'] as String?,
  regimentId: json['regimentId'] as String,
  eventKind: $enumDecode(_$EventKindEnumMap, json['eventKind']),
  title: json['title'] as String,
  description: json['description'] as String,
  documentSource: json['documentSource'] as String,
  documentSourcePage: (json['documentSourcePage'] as num).toInt(),
  startDate:
      json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
  endDate:
      json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
  coordinatesForMap:
      json['coordinatesForMap'] == null
          ? null
          : GpsCoordinates.fromJson(
            json['coordinatesForMap'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$$WarEventOriginalImplToJson(
  _$WarEventOriginalImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'regimentId': instance.regimentId,
  'eventKind': _$EventKindEnumMap[instance.eventKind]!,
  'title': instance.title,
  'description': instance.description,
  'documentSource': instance.documentSource,
  'documentSourcePage': instance.documentSourcePage,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'coordinatesForMap': instance.coordinatesForMap,
};

const _$EventKindEnumMap = {
  EventKind.political: 'political',
  EventKind.military: 'military',
  EventKind.unitMovement: 'unitMovement',
  EventKind.other: 'other',
};
