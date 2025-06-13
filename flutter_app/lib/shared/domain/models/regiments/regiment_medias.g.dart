// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regiment_medias.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegimentMedias _$RegimentMediasFromJson(Map<String, dynamic> json) =>
    RegimentMedias(
      pages:
          (json['pages'] as List<dynamic>?)?.map((e) => e as String).toList(),
      pdf: json['pdf'] as String?,
    );

Map<String, dynamic> _$RegimentMediasToJson(RegimentMedias instance) =>
    <String, dynamic>{'pages': instance.pages, 'pdf': instance.pdf};
