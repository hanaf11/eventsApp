// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'komentar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Komentar _$KomentarFromJson(Map<String, dynamic> json) => Komentar(
      komentarId: (json['komentarId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      dogadjajId: (json['dogadjajId'] as num?)?.toInt(),
      komentar: json['komentar'] as String?,
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KomentarToJson(Komentar instance) => <String, dynamic>{
      'komentarId': instance.komentarId,
      'korisnikId': instance.korisnikId,
      'dogadjajId': instance.dogadjajId,
      'komentar': instance.komentar,
      'korisnik': instance.korisnik,
    };
