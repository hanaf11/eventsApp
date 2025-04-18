// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnici_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisniciReportResponse _$KorisniciReportResponseFromJson(
        Map<String, dynamic> json) =>
    KorisniciReportResponse(
      (json['numberOfRegistered'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
      (json['mostOrdersUsers'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
      (json['mostActiveUsers'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
      (json['mostSubscribedCategories'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
    );

Map<String, dynamic> _$KorisniciReportResponseToJson(
        KorisniciReportResponse instance) =>
    <String, dynamic>{
      'numberOfRegistered': instance.numberOfRegistered,
      'mostOrdersUsers': instance.mostOrdersUsers,
      'mostActiveUsers': instance.mostActiveUsers,
      'mostSubscribedCategories': instance.mostSubscribedCategories,
    };
