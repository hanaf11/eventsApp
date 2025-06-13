import 'package:json_annotation/json_annotation.dart';

part 'stavke_narudzbe.g.dart';

@JsonSerializable()
class StavkeNarudzbe {
  int? narudzbaStavkaId;
  int? narudzbaId;
  int? tipKarteId;
  double? cijena;
  int? kolicina;
  String? tipKarte;
  String? dogadjaj;

  StavkeNarudzbe(this.narudzbaStavkaId, this.narudzbaId, this.tipKarteId,
      this.cijena, this.kolicina, this.tipKarte, this.dogadjaj);

  factory StavkeNarudzbe.fromJson(Map<String, dynamic> json) =>
      _$StavkeNarudzbeFromJson(json);

  Map<String, dynamic> toJson() => _$StavkeNarudzbeToJson(this);
}
