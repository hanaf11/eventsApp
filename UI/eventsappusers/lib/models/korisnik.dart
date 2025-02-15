import 'dart:ffi';

import 'package:eventsappusers/models/kategorija.dart';
import 'package:json_annotation/json_annotation.dart';

part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? korisnikId;
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  String? korisnickoIme;
  bool? status;
  DateTime? created;
  String? adresa;
  String? drzava;
  String? slika;
  String? password;
  String? passwordPotvrda;

  Korisnik(
      this.korisnikId,
      this.ime,
      this.prezime,
      this.email,
      this.telefon,
      this.korisnickoIme,
      this.status,
      this.created,
      this.adresa,
      this.drzava,
      this.slika,
      this.password,
      this.passwordPotvrda);

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
