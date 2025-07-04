import 'package:json_annotation/json_annotation.dart';

part 'korisnici_report_response.g.dart';

@JsonSerializable()
class KorisniciReportResponse {
  List<Map<String, Object>>? numberOfRegistered;
  List<Map<String, Object>>? mostOrdersUsers;
  List<Map<String, Object>>? mostActiveUsers;
  List<Map<String, Object>>? mostSubscribedCategories;

  KorisniciReportResponse(this.numberOfRegistered, this.mostOrdersUsers,
      this.mostActiveUsers, this.mostSubscribedCategories);

  factory KorisniciReportResponse.fromJson(Map<String, dynamic> json) =>
      _$KorisniciReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KorisniciReportResponseToJson(this);
}
