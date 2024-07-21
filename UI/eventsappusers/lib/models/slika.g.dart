// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slika.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slika _$SlikaFromJson(Map<String, dynamic> json) => Slika(
      (json['slikaId'] as num?)?.toInt(),
      json['slika'] as String?,
    );

Map<String, dynamic> _$SlikaToJson(Slika instance) => <String, dynamic>{
      'slikaId': instance.slikaId,
      'slika': instance.slika,
    };
