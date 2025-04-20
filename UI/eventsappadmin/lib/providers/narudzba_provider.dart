import 'dart:convert';

import 'package:eventsappadmin/models/dogadjaj.dart';
import 'package:eventsappadmin/models/dogadjaji_report_response.dart';
import 'package:eventsappadmin/models/narudzba.dart';
import 'package:eventsappadmin/models/narudzbe_report_response.dart';
import 'package:eventsappadmin/models/search_result.dart';
import 'package:eventsappadmin/providers/base_provider.dart';
import 'package:eventsappadmin/screens/zahtjevi_list_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NarudzbaProvider extends BaseProvider<Narudzba> {
  static String? _baseUrl;
  NarudzbaProvider() : super("Narudzba") {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7294/");
  }

  Future<NarudzbeReportResponse> getReportData({dynamic filter}) async {
    var url = "${_baseUrl}Narudzba/report";
    if (filter != null) {
      var queryString = BaseProvider.getQueryString(filter);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    var response = await http.get(uri, headers: headers);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = reportfromJson(data);

      return result;
    } else {
      throw new Exception("Unknown exception");
    }
  }

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }

  NarudzbeReportResponse reportfromJson(data) {
    return NarudzbeReportResponse.fromJson(data);
  }
}
