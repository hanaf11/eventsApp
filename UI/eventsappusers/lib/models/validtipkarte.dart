import 'package:json_annotation/json_annotation.dart';

part 'validtipkarte.g.dart';

@JsonSerializable()
class ValidTipKarte {
  int? tipKarteId;
  String? naziv;
  double? cijena;
  int? kolicina;

  ValidTipKarte(this.tipKarteId, this.naziv, this.cijena, this.kolicina);

  factory ValidTipKarte.fromJson(Map<String, dynamic> json) =>
      _$ValidTipKarteFromJson(json);

  Map<String, dynamic> toJson() => _$ValidTipKarteToJson(this);
}
