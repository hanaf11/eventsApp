import 'package:eventsappusers/models/validtipkarte.dart';
import 'package:json_annotation/json_annotation.dart';
part 'narudzba.g.dart';

@JsonSerializable()
class Narudzba {
  List<ValidTipKarte>? listaKarata;
  String? ime;
  String? prezime;
  String? adresa;
  int? postanskiBroj;
  String? grad;
  String? drzava;
  String? email;
  String? telefon;
  int? korisnikId;
  String? tip;
  double? cijena;

  Narudzba(this.listaKarata);

  Narudzba.allArgs(
      this.listaKarata,
      this.ime,
      this.prezime,
      this.adresa,
      this.postanskiBroj,
      this.grad,
      this.drzava,
      this.email,
      this.telefon,
      this.korisnikId,
      this.tip,
      this.cijena);
  factory Narudzba.fromJson(Map<String, dynamic> json) =>
      _$NarudzbaFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbaToJson(this);
}
