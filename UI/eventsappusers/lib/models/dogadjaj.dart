import 'package:eventsappusers/models/kategorija.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dogadjaj.g.dart';

@JsonSerializable()
class Dogadjaj {
  int? dogadjajId;
  String? naziv;
  DateTime? datumOd;
  DateTime? datumDo;
  String? lokacija;
  int? kategorijaId;
  Kategorija? kategorija;
  String? naslovna;
  String? program;
  String? programSlika;
  String? opis;
  String? website;
  String? lokacijaSlika;
  int? podkategorijaId;

  Dogadjaj(
      this.dogadjajId,
      this.naziv,
      this.kategorijaId,
      this.datumOd,
      this.datumDo,
      this.lokacija,
      this.kategorija,
      this.naslovna,
      this.program,
      this.programSlika,
      this.opis,
      this.website,
      this.lokacijaSlika,
      this.podkategorijaId);

  factory Dogadjaj.fromJson(Map<String, dynamic> json) =>
      _$DogadjajFromJson(json);

  Map<String, dynamic> toJson() => _$DogadjajToJson(this);
}
