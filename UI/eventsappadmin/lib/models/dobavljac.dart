import 'package:json_annotation/json_annotation.dart';

part 'dobavljac.g.dart';

@JsonSerializable()
class Dobavljac {
  int? dobavljacId;
  String? naziv;
  String? adresa;
  String? telefon;
  String? fax;
  String? web;
  String? email;
  String? ziroRacun;
  String? napomena;
  bool? status;

  Dobavljac(
    this.dobavljacId,
    this.naziv,
    this.adresa,
    this.telefon,
    this.fax,
    this.web,
    this.email,
    this.ziroRacun,
    this.napomena,
    this.status,
  );

  factory Dobavljac.fromJson(Map<String, dynamic> json) =>
      _$DobavljacFromJson(json);

  Map<String, dynamic> toJson() => _$DobavljacToJson(this);
}
