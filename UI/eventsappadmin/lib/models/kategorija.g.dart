// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kategorija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kategorija _$KategorijaFromJson(Map<String, dynamic> json) => Kategorija(
      (json['kategorijaId'] as num?)?.toInt(),
      json['naziv'] as String?,
      json['opis'] as String?,
      json['slika'] as String?,
    );

Map<String, dynamic> _$KategorijaToJson(Kategorija instance) =>
    <String, dynamic>{
      'kategorijaId': instance.kategorijaId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'slika': instance.slika,
    };
