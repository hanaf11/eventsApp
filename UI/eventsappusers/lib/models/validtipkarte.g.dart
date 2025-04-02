// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validtipkarte.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidTipKarte _$ValidTipKarteFromJson(Map<String, dynamic> json) =>
    ValidTipKarte(
      (json['tipKarteId'] as num?)?.toInt(),
      json['naziv'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      (json['kolicina'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ValidTipKarteToJson(ValidTipKarte instance) =>
    <String, dynamic>{
      'tipKarteId': instance.tipKarteId,
      'naziv': instance.naziv,
      'cijena': instance.cijena,
      'kolicina': instance.kolicina,
    };
