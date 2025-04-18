import 'dart:convert';

import 'package:eventsappadmin/models/dogadjaj.dart';
import 'package:eventsappadmin/models/korisnici_report_response.dart';
import 'package:eventsappadmin/models/search_result.dart';
import 'package:eventsappadmin/providers/base_provider.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/korisnik.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  static String? _baseUrl;
  KorisnikProvider() : super("Korisnici") {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7294/");
  }

  Future<Korisnik> login(dynamic credentials) async {
    var url = "${_baseUrl}Korisnici/login";
    var queryString = BaseProvider.getQueryString(credentials);
    url = "$url?$queryString";
    var uri = Uri.parse(url);
    print("moj uri ${uri}");
    var headers = BaseProvider.createHeaders();

    var response = await http.get(uri, headers: headers);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown exception");
    }
  }

  Future<KorisniciReportResponse> getReportData({dynamic filter}) async {
    var url = "${_baseUrl}Korisnici/report";
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
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }

  KorisniciReportResponse reportfromJson(data) {
    return KorisniciReportResponse.fromJson(data);
  }
}
