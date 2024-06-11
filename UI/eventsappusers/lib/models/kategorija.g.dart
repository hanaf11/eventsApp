// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kategorija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kategorija _$KategorijaFromJson(Map<String, dynamic> json) => Kategorija(
      kategorijaId: (json['kategorijaId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
      opis: json['opis'] as String?,
      slika: json['slika'] as String?,
    );

Map<String, dynamic> _$KategorijaToJson(Kategorija instance) =>
    <String, dynamic>{
      'kategorijaId': instance.kategorijaId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'slika': instance.slika,
    };
