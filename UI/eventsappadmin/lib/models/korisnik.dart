import 'package:eventsappadmin/models/slika.dart';
import 'package:json_annotation/json_annotation.dart';

import 'narudzba.dart';

part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int korisnikId;
  String korisnickoIme;
  DateTime created;
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  bool? status;
  String? adresa;
  String? drzava;
  String? slika;
  List<Narudzba>? narudzbes;

  Korisnik(
      this.korisnikId,
      this.korisnickoIme,
      this.created,
      this.ime,
      this.prezime,
      this.email,
      this.telefon,
      this.status,
      this.adresa,
      this.drzava,
      this.slika,
      this.narudzbes);

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
