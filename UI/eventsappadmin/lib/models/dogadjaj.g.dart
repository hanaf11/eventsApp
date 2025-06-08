// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dogadjaj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dogadjaj _$DogadjajFromJson(Map<String, dynamic> json) => Dogadjaj(
      (json['dogadjajId'] as num?)?.toInt(),
      json['naziv'] as String?,
      json['program'] as String?,
      json['opis'] as String?,
      json['naslovna'] as String?,
      (json['kategorijaId'] as num?)?.toInt(),
      (json['podkategorijaId'] as num?)?.toInt(),
      json['datumOd'] == null
          ? null
          : DateTime.parse(json['datumOd'] as String),
      json['datumDo'] == null
          ? null
          : DateTime.parse(json['datumDo'] as String),
      json['lokacija'] as String?,
      (json['dobavljacId'] as num?)?.toInt(),
      json['organizator'] as String?,
      json['website'] as String?,
      (json['galerija'] as List<dynamic>?)
          ?.map((e) => Slika.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['programSlika'] as String?,
      json['lokacijaSlika'] as String?,
      json['status'] as String?,
      json['dobavljac'] == null
          ? null
          : Dobavljac.fromJson(json['dobavljac'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DogadjajToJson(Dogadjaj instance) => <String, dynamic>{
      'dogadjajId': instance.dogadjajId,
      'naziv': instance.naziv,
      'datumOd': instance.datumOd?.toIso8601String(),
      'datumDo': instance.datumDo?.toIso8601String(),
      'lokacija': instance.lokacija,
      'dobavljacId': instance.dobavljacId,
      'program': instance.program,
      'opis': instance.opis,
      'naslovna': instance.naslovna,
      'kategorijaId': instance.kategorijaId,
      'podkategorijaId': instance.podkategorijaId,
      'organizator': instance.organizator,
      'website': instance.website,
      'galerija': instance.galerija,
      'programSlika': instance.programSlika,
      'lokacijaSlika': instance.lokacijaSlika,
      'status': instance.status,
      'dobavljac': instance.dobavljac,
    };
