import 'package:json_annotation/json_annotation.dart';

part 'dogadjaji_report_response.g.dart';

@JsonSerializable()
class DogadjajiReportResponse {
  List<Map<String, Object>>? eventsByStatus;
  List<Map<String, Object>>? eventsByCategory;
  List<Map<String, Object>>? topSellingEvents;
  List<Map<String, Object>>? mostViewedEvents;
  List<Map<String, Object>>? mostSavedEvents;

  DogadjajiReportResponse(this.eventsByStatus, this.eventsByCategory,
      this.topSellingEvents, this.mostViewedEvents, this.mostSavedEvents);

  factory DogadjajiReportResponse.fromJson(Map<String, dynamic> json) =>
      _$DogadjajiReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DogadjajiReportResponseToJson(this);
}
