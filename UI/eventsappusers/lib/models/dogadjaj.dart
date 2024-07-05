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

  Dogadjaj(this.dogadjajId, this.naziv, this.kategorijaId, this.datumOd,
      this.datumDo, this.lokacija, this.kategorija, this.naslovna);

  factory Dogadjaj.fromJson(Map<String, dynamic> json) =>
      _$DogadjajFromJson(json);

  Map<String, dynamic> toJson() => _$DogadjajToJson(this);
}
