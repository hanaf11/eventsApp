// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      json['korisnikId'] as int,
      json['brojNarudzbe'] as int,
      DateTime.parse(json['datum'] as String),
      (json['iznosSaPdv'] as num).toDouble(),
    );

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'brojNarudzbe': instance.brojNarudzbe,
      'datum': instance.datum.toIso8601String(),
      'iznosSaPdv': instance.iznosSaPdv,
    };
