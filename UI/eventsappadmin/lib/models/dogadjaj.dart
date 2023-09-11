import 'package:json_annotation/json_annotation.dart';

part 'dogadjaj.g.dart';

@JsonSerializable()
class Dogadjaj {
  int? dogadjajId;
  String? naziv;
  DateTime? datumOd;
  String? lokacija;
  int? dobavljacId;
  String? program;
  String? opis;
  String? naslovna;
  int? kategorijaId;

  Dogadjaj(this.dogadjajId, this.naziv, this.program, this.opis, this.naslovna,
      this.kategorijaId, this.datumOd, this.lokacija, this.dobavljacId);

  factory Dogadjaj.fromJson(Map<String, dynamic> json) =>
      _$DogadjajFromJson(json);

  Map<String, dynamic> toJson() => _$DogadjajToJson(this);
}
