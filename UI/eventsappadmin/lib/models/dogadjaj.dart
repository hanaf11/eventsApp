import 'package:json_annotation/json_annotation.dart';

part 'dogadjaj.g.dart';

@JsonSerializable()
class Dogadjaj {
  int? dogadjajId;
  String? naziv;
  DateTime? datumOd;
  DateTime? datumDo;
  String? lokacija;
  int? dobavljacId;
  String? program;
  String? opis;
  String? naslovna;
  int? kategorijaId;
  int? podkategorijaId;
  String? organizator;
  String? website;

  Dogadjaj(
      this.dogadjajId,
      this.naziv,
      this.program,
      this.opis,
      this.naslovna,
      this.kategorijaId,
      this.podkategorijaId,
      this.datumOd,
      this.datumDo,
      this.lokacija,
      this.dobavljacId,
      this.organizator,
      this.website);

  factory Dogadjaj.fromJson(Map<String, dynamic> json) =>
      _$DogadjajFromJson(json);

  Map<String, dynamic> toJson() => _$DogadjajToJson(this);
}
