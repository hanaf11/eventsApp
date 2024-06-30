// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dobavljac.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dobavljac _$DobavljacFromJson(Map<String, dynamic> json) => Dobavljac(
      json['dobavljacId'] as int?,
      json['naziv'] as String?,
      json['adresa'] as String?,
      json['telefon'] as String?,
      json['fax'] as String?,
      json['web'] as String?,
      json['email'] as String?,
      json['ziroRacun'] as String?,
      json['napomena'] as String?,
      json['status'] as bool?,
    );

Map<String, dynamic> _$DobavljacToJson(Dobavljac instance) => <String, dynamic>{
      'dobavljacId': instance.dobavljacId,
      'naziv': instance.naziv,
      'adresa': instance.adresa,
      'telefon': instance.telefon,
      'fax': instance.fax,
      'web': instance.web,
      'email': instance.email,
      'ziroRacun': instance.ziroRacun,
      'napomena': instance.napomena,
      'status': instance.status,
    };
