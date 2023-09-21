import 'package:json_annotation/json_annotation.dart';

part 'podkategorija.g.dart';

@JsonSerializable()
class Podkategorija {
  int podkategorijaId;
  String naziv;
  int kategorijaId;

  Podkategorija(this.podkategorijaId, this.naziv, this.kategorijaId);

  factory Podkategorija.fromJson(Map<String, dynamic> json) =>
      _$PodkategorijaFromJson(json);

  Map<String, dynamic> toJson() => _$PodkategorijaToJson(this);
}
