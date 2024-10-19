// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipkarte.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipKarte _$TipKarteFromJson(Map<String, dynamic> json) => TipKarte(
      json['dogadjajId'] as int?,
      json['naziv'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['stanje'] as int?,
      json['numerisanjeSjedista'] as bool?,
    );

Map<String, dynamic> _$TipKarteToJson(TipKarte instance) => <String, dynamic>{
      'dogadjajId': instance.dogadjajId,
      'naziv': instance.naziv,
      'cijena': instance.cijena,
      'stanje': instance.stanje,
      'numerisanjeSjedista': instance.numerisanjeSjedista,
    };
