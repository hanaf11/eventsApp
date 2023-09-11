// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dogadjaj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dogadjaj _$DogadjajFromJson(Map<String, dynamic> json) => Dogadjaj(
      json['dogadjajId'] as int?,
      json['naziv'] as String?,
      json['program'] as String?,
      json['opis'] as String?,
      json['naslovna'] as String?,
      json['kategorijaId'] as int?,
      json['datumOd'] == null
          ? null
          : DateTime.parse(json['datumOd'] as String),
      json['lokacija'] as String?,
      json['dobavljacId'] as int?,
    );

Map<String, dynamic> _$DogadjajToJson(Dogadjaj instance) => <String, dynamic>{
      'dogadjajId': instance.dogadjajId,
      'naziv': instance.naziv,
      'datumOd': instance.datumOd?.toIso8601String(),
      'lokacija': instance.lokacija,
      'dobavljacId': instance.dobavljacId,
      'program': instance.program,
      'opis': instance.opis,
      'naslovna': instance.naslovna,
      'kategorijaId': instance.kategorijaId,
    };
