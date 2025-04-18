// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzbe_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NarudzbeReportResponse _$NarudzbeReportResponseFromJson(
        Map<String, dynamic> json) =>
    NarudzbeReportResponse(
      (json['numOfOrders'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
      (json['revenue'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
      (json['numOfSoldTickets'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
      (json['mostSoldEvents'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
    );

Map<String, dynamic> _$NarudzbeReportResponseToJson(
        NarudzbeReportResponse instance) =>
    <String, dynamic>{
      'numOfOrders': instance.numOfOrders,
      'revenue': instance.revenue,
      'numOfSoldTickets': instance.numOfSoldTickets,
      'mostSoldEvents': instance.mostSoldEvents,
    };
