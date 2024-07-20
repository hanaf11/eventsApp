// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dogadjaj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dogadjaj _$DogadjajFromJson(Map<String, dynamic> json) => Dogadjaj(
      (json['dogadjajId'] as num?)?.toInt(),
      json['naziv'] as String?,
      (json['kategorijaId'] as num?)?.toInt(),
      json['datumOd'] == null
          ? null
          : DateTime.parse(json['datumOd'] as String),
      json['datumDo'] == null
          ? null
          : DateTime.parse(json['datumDo'] as String),
      json['lokacija'] as String?,
      json['kategorija'] == null
          ? null
          : Kategorija.fromJson(json['kategorija'] as Map<String, dynamic>),
      json['naslovna'] as String?,
      json['program'] as String?,
      json['programSlika'] as String?,
      json['opis'] as String?,
      json['website'] as String?,
      json['lokacijaSlika'] as String?,
      (json['podkategorijaId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DogadjajToJson(Dogadjaj instance) => <String, dynamic>{
      'dogadjajId': instance.dogadjajId,
      'naziv': instance.naziv,
      'datumOd': instance.datumOd?.toIso8601String(),
      'datumDo': instance.datumDo?.toIso8601String(),
      'lokacija': instance.lokacija,
      'kategorijaId': instance.kategorijaId,
      'kategorija': instance.kategorija,
      'naslovna': instance.naslovna,
      'program': instance.program,
      'programSlika': instance.programSlika,
      'opis': instance.opis,
      'website': instance.website,
      'lokacijaSlika': instance.lokacijaSlika,
      'podkategorijaId': instance.podkategorijaId,
    };
