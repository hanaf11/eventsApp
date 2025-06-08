// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      narudzbaId: (json['narudzbaId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      brojNarudzbe: json['brojNarudzbe'] as String?,
      datum: json['datum'] == null
          ? null
          : DateTime.parse(json['datum'] as String),
      cijena: (json['cijena'] as num?)?.toDouble(),
      korisnickoIme: json['korisnickoIme'] as String?,
      email: json['email'] as String?,
      ime: json['ime'] as String?,
      prezime: json['prezime'] as String?,
      telefon: json['telefon'] as String?,
      adresa: json['adresa'] as String?,
      postanskiBroj: (json['postanskiBroj'] as num?)?.toInt(),
      grad: json['grad'] as String?,
      drzava: json['drzava'] as String?,
      tip: json['tip'] as String?,
    );

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'narudzbaId': instance.narudzbaId,
      'korisnikId': instance.korisnikId,
      'brojNarudzbe': instance.brojNarudzbe,
      'datum': instance.datum?.toIso8601String(),
      'cijena': instance.cijena,
      'korisnickoIme': instance.korisnickoIme,
      'email': instance.email,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'telefon': instance.telefon,
      'adresa': instance.adresa,
      'postanskiBroj': instance.postanskiBroj,
      'grad': instance.grad,
      'drzava': instance.drzava,
      'tip': instance.tip,
    };
