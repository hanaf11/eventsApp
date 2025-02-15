// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      (json['korisnikId'] as num?)?.toInt(),
      json['ime'] as String?,
      json['prezime'] as String?,
      json['email'] as String?,
      json['telefon'] as String?,
      json['korisnickoIme'] as String?,
      json['status'] as bool?,
      json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      json['adresa'] as String?,
      json['drzava'] as String?,
      json['slika'] as String?,
      json['password'] as String?,
      json['passwordPotvrda'] as String?,
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'telefon': instance.telefon,
      'korisnickoIme': instance.korisnickoIme,
      'status': instance.status,
      'created': instance.created?.toIso8601String(),
      'adresa': instance.adresa,
      'drzava': instance.drzava,
      'slika': instance.slika,
      'password': instance.password,
      'passwordPotvrda': instance.passwordPotvrda,
    };
