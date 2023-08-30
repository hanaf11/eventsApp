import 'package:json_annotation/json_annotation.dart';

part 'dogadjaj.g.dart';

@JsonSerializable()
class Dogadjaj {
  int? dogadjajId;
  String? naziv;
  String? program;
  String? opis;
  String? naslovna;
  int? kategorijaId;

  Dogadjaj(this.dogadjajId, this.naziv, this.program, this.opis, this.naslovna,
      this.kategorijaId);

  factory Dogadjaj.fromJson(Map<String, dynamic> json) =>
      _$DogadjajFromJson(json);

  Map<String, dynamic> toJson() => _$DogadjajToJson(this);
}
