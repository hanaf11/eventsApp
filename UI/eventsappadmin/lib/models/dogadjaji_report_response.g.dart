// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dogadjaji_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DogadjajiReportResponse _$DogadjajiReportResponseFromJson(
        Map<String, dynamic> json) =>
    DogadjajiReportResponse(
      (json['eventsByStatus'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
      (json['eventsByCategory'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
      (json['topSellingEvents'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
      (json['mostViewedEvents'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
      (json['mostSavedEvents'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as Object),
              ))
          .toList(),
    );

Map<String, dynamic> _$DogadjajiReportResponseToJson(
        DogadjajiReportResponse instance) =>
    <String, dynamic>{
      'eventsByStatus': instance.eventsByStatus,
      'eventsByCategory': instance.eventsByCategory,
      'topSellingEvents': instance.topSellingEvents,
      'mostViewedEvents': instance.mostViewedEvents,
      'mostSavedEvents': instance.mostSavedEvents,
    };
