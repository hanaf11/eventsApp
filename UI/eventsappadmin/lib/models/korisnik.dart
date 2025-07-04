import 'package:json_annotation/json_annotation.dart';

import 'narudzba.dart';

part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? korisnikId;
  String? korisnickoIme;
  DateTime? created;
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  bool? status;
  String? adresa;
  String? drzava;
  String? slika;
  int? uloga;
  String? password;
  String? passwordPotvrda;
  List<Narudzba>? narudzbes;
  List<String>? uloge;

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
      this.uloga,
      this.password,
      this.passwordPotvrda,
      this.narudzbes,
      this.uloge);

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
