// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stavke_narudzbe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StavkeNarudzbe _$StavkeNarudzbeFromJson(Map<String, dynamic> json) =>
    StavkeNarudzbe(
      (json['narudzbaStavkaId'] as num?)?.toInt(),
      (json['narudzbaId'] as num?)?.toInt(),
      (json['tipKarteId'] as num?)?.toInt(),
      (json['cijena'] as num?)?.toDouble(),
      (json['kolicina'] as num?)?.toInt(),
      json['tipKarte'] as String?,
    );

Map<String, dynamic> _$StavkeNarudzbeToJson(StavkeNarudzbe instance) =>
    <String, dynamic>{
      'narudzbaStavkaId': instance.narudzbaStavkaId,
      'narudzbaId': instance.narudzbaId,
      'tipKarteId': instance.tipKarteId,
      'cijena': instance.cijena,
      'kolicina': instance.kolicina,
      'tipKarte': instance.tipKarte,
    };
