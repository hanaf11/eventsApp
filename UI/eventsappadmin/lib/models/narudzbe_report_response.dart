import 'package:eventsappadmin/models/slika.dart';
import 'package:json_annotation/json_annotation.dart';

part 'narudzbe_report_response.g.dart';

@JsonSerializable()
class NarudzbeReportResponse {
  List<Map<String, Object>>? numOfOrders;
  List<Map<String, Object>>? revenue;
  List<Map<String, Object>>? numOfSoldTickets;
  List<Map<String, Object>>? mostSoldEvents;

  NarudzbeReportResponse(this.numOfOrders, this.revenue, this.numOfSoldTickets,
      this.mostSoldEvents);

  factory NarudzbeReportResponse.fromJson(Map<String, dynamic> json) =>
      _$NarudzbeReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbeReportResponseToJson(this);
}
