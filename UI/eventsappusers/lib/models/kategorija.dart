import 'package:eventsappusers/models/podkategorija.dart';
import 'package:json_annotation/json_annotation.dart';
part 'kategorija.g.dart';

@JsonSerializable()
class Kategorija {
  int? kategorijaId;
  String? naziv;
  String? opis;
  String? slika;
  List<Podkategorija>? podkategorijes;

  Kategorija(
      {this.kategorijaId,
      this.naziv,
      this.opis,
      this.slika,
      this.podkategorijes});
  factory Kategorija.fromJson(Map<String, dynamic> json) =>
      _$KategorijaFromJson(json);

  Map<String, dynamic> toJson() => _$KategorijaToJson(this);
}
