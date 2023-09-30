// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      json['korisnikId'] as int,
      json['korisnickoIme'] as String,
      DateTime.parse(json['created'] as String),
      json['ime'] as String?,
      json['prezime'] as String?,
      json['email'] as String?,
      json['telefon'] as String?,
      json['status'] as bool?,
      json['adresa'] as String?,
      json['drzava'] as String?,
      json['slika'] as String?,
      (json['narudzbes'] as List<dynamic>?)
          ?.map((e) => Narudzba.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'korisnickoIme': instance.korisnickoIme,
      'created': instance.created.toIso8601String(),
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'telefon': instance.telefon,
      'status': instance.status,
      'adresa': instance.adresa,
      'drzava': instance.drzava,
      'slika': instance.slika,
      'narudzbes': instance.narudzbes,
    };
