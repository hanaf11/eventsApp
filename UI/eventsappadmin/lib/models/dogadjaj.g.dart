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
    );

Map<String, dynamic> _$DogadjajToJson(Dogadjaj instance) => <String, dynamic>{
      'dogadjajId': instance.dogadjajId,
      'naziv': instance.naziv,
      'program': instance.program,
      'opis': instance.opis,
      'naslovna': instance.naslovna,
      'kategorijaId': instance.kategorijaId,
    };
