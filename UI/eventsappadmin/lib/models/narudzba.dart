import 'package:eventsappadmin/models/slika.dart';
import 'package:json_annotation/json_annotation.dart';

part 'narudzba.g.dart';

@JsonSerializable()
class Narudzba {
  int? narudzbaId;
  int? korisnikId;
  String? brojNarudzbe;
  DateTime? datum;
  double? cijena;
  String? korisnickoIme;
  String? email;
  String? ime;
  String? prezime;
  String? telefon;
  String? adresa;
  int? postanskiBroj;
  String? grad;
  String? drzava;
  String? tip;

  Narudzba(
      {required this.narudzbaId,
      required this.korisnikId,
      required this.brojNarudzbe,
      required this.datum,
      required this.cijena,
      required this.korisnickoIme,
      required this.email,
      required this.ime,
      required this.prezime,
      required this.telefon,
      this.adresa,
      required this.postanskiBroj,
      required this.grad,
      this.drzava,
      this.tip});

  factory Narudzba.fromJson(Map<String, dynamic> json) =>
      _$NarudzbaFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbaToJson(this);
}
