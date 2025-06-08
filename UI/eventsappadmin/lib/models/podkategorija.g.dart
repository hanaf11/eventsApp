// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podkategorija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Podkategorija _$PodkategorijaFromJson(Map<String, dynamic> json) =>
    Podkategorija(
      (json['podkategorijaId'] as num).toInt(),
      json['naziv'] as String,
      (json['kategorijaId'] as num).toInt(),
    );

Map<String, dynamic> _$PodkategorijaToJson(Podkategorija instance) =>
    <String, dynamic>{
      'podkategorijaId': instance.podkategorijaId,
      'naziv': instance.naziv,
      'kategorijaId': instance.kategorijaId,
    };
