import 'package:eventsappusers/models/korisnik.dart';
import 'package:json_annotation/json_annotation.dart';
part 'komentar.g.dart';

@JsonSerializable()
class Komentar {
  int? komentarId;
  int? korisnikId;
  int? dogadjajId;
  String? komentar;
  Korisnik? korisnik;

  Komentar(
      {this.komentarId,
      this.korisnikId,
      this.dogadjajId,
      this.komentar,
      this.korisnik});
  factory Komentar.fromJson(Map<String, dynamic> json) =>
      _$KomentarFromJson(json);

  Map<String, dynamic> toJson() => _$KomentarToJson(this);
}
