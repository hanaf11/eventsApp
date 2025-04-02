// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      (json['listaKarata'] as List<dynamic>?)
          ?.map((e) => ValidTipKarte.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..ime = json['ime'] as String?
      ..prezime = json['prezime'] as String?
      ..adresa = json['adresa'] as String?
      ..postanskiBroj = (json['postanskiBroj'] as num?)?.toInt()
      ..grad = json['grad'] as String?
      ..drzava = json['drzava'] as String?
      ..email = json['email'] as String?
      ..telefon = json['telefon'] as String?
      ..korisnikId = (json['korisnikId'] as num?)?.toInt()
      ..tip = json['tip'] as String?
      ..brojKartice = (json['brojKartice'] as num?)?.toInt()
      ..datumKartice = json['datumKartice'] as String?
      ..cvv = (json['cvv'] as num?)?.toInt()
      ..imePrezimeKartica = json['imePrezimeKartica'] as String?
      ..cijena = (json['cijena'] as num?)?.toDouble();

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'listaKarata': instance.listaKarata,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'adresa': instance.adresa,
      'postanskiBroj': instance.postanskiBroj,
      'grad': instance.grad,
      'drzava': instance.drzava,
      'email': instance.email,
      'telefon': instance.telefon,
      'korisnikId': instance.korisnikId,
      'tip': instance.tip,
      'brojKartice': instance.brojKartice,
      'datumKartice': instance.datumKartice,
      'cvv': instance.cvv,
      'imePrezimeKartica': instance.imePrezimeKartica,
      'cijena': instance.cijena,
    };
