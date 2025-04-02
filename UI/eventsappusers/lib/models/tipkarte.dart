import 'package:json_annotation/json_annotation.dart';

part 'tipkarte.g.dart';

@JsonSerializable()
class TipKarte {
  int? tipKarteId;
  int? dogadjajId;
  String? naziv;
  double? cijena;
  int? stanje;
  bool? numerisanjeSjedista;

  TipKarte(this.tipKarteId, this.dogadjajId, this.naziv, this.cijena,
      this.stanje, this.numerisanjeSjedista);

  factory TipKarte.fromJson(Map<String, dynamic> json) =>
      _$TipKarteFromJson(json);

  Map<String, dynamic> toJson() => _$TipKarteToJson(this);
}
