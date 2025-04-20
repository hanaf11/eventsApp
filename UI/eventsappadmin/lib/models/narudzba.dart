import 'package:eventsappadmin/models/slika.dart';
import 'package:json_annotation/json_annotation.dart';

part 'narudzba.g.dart';

@JsonSerializable()
class Narudzba {
  int korisnikId;
  String brojNarudzbe;
  DateTime datum;
  double cijena;
  String korisnickoIme;

  Narudzba(this.korisnikId, this.brojNarudzbe, this.datum, this.cijena,
      this.korisnickoIme);

  factory Narudzba.fromJson(Map<String, dynamic> json) =>
      _$NarudzbaFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbaToJson(this);
}
