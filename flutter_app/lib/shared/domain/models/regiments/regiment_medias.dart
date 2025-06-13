import 'package:json_annotation/json_annotation.dart';

part 'regiment_medias.g.dart';

@JsonSerializable()
class RegimentMedias {
  final List<String>? pages;
  final String? pdf;

  RegimentMedias({
    required this.pages,
    this.pdf,
  });

  factory RegimentMedias.fromJson(Map<String, dynamic> json) =>
      _$RegimentMediasFromJson(json);

  Map<String, dynamic> toJson() => _$RegimentMediasToJson(this);

}
