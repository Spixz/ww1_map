import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/domain/mappers/object_id_from_json.dart';

import 'package:ww1_map/shared/domain/models/regiments/regiment_medias.dart';

part "regiment.g.dart";

@JsonSerializable(fieldRename: FieldRename.snake)
class Regiment {
  @JsonKey(name: "_id", fromJson: objectIdFromJson)
  final ObjectId id;
  final String title;
  final String arkName;
  final int nbMedias;
  final RegimentMedias medias;
  final String? description;

  const Regiment({
    required this.id,
    required this.title,
    required this.arkName,
    required this.nbMedias,
    required this.medias,
    this.description
  });

  factory Regiment.fromJson(Map<String, dynamic> json) =>
      _$RegimentFromJson(json);
  Map<String, dynamic> toJson() => _$RegimentToJson(this);
}
