import 'package:json_annotation/json_annotation.dart';

part 'slika.g.dart';

@JsonSerializable()
class Slika {
  int? slikaId;
  String? slika;

  Slika(this.slikaId, this.slika);

  factory Slika.fromJson(Map<String, dynamic> json) => _$SlikaFromJson(json);

  Map<String, dynamic> toJson() => _$SlikaToJson(this);
}
