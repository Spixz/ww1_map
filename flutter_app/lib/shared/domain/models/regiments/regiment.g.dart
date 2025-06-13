// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regiment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Regiment _$RegimentFromJson(Map<String, dynamic> json) => Regiment(
  id: objectIdFromJson(json['_id'] as ObjectId),
  title: json['title'] as String,
  arkName: json['ark_name'] as String,
  nbMedias: (json['nb_medias'] as num).toInt(),
  medias: RegimentMedias.fromJson(json['medias'] as Map<String, dynamic>),
  description: json['description'] as String?,
);

Map<String, dynamic> _$RegimentToJson(Regiment instance) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'ark_name': instance.arkName,
  'nb_medias': instance.nbMedias,
  'medias': instance.medias,
  'description': instance.description,
};
