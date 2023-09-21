// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podkategorija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Podkategorija _$PodkategorijaFromJson(Map<String, dynamic> json) =>
    Podkategorija(
      json['podkategorijaId'] as int,
      json['naziv'] as String,
      json['kategorijaId'] as int,
    );

Map<String, dynamic> _$PodkategorijaToJson(Podkategorija instance) =>
    <String, dynamic>{
      'podkategorijaId': instance.podkategorijaId,
      'naziv': instance.naziv,
      'kategorijaId': instance.kategorijaId,
    };
