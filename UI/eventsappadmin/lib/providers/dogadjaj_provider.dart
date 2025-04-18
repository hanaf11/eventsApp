import 'dart:convert';

import 'package:eventsappadmin/models/dogadjaj.dart';
import 'package:eventsappadmin/models/dogadjaji_report_response.dart';
import 'package:eventsappadmin/models/search_result.dart';
import 'package:eventsappadmin/providers/base_provider.dart';
import 'package:eventsappadmin/screens/zahtjevi_list_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DogadjajProvider extends BaseProvider<Dogadjaj> {
  static String? _baseUrl;
  DogadjajProvider() : super("Dogadjaji") {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7294/");
  }

  Future<Dogadjaj> hide(int id) async {
    var url = "${_baseUrl}Dogadjaji/$id/hide";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    print("my url is $url");

    var response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown exception");
    }
  }

  Future<Dogadjaj> accept(int id) async {
    var url = "${_baseUrl}Dogadjaji/$id/verify";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    print("my url is $url");

    var response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown exception");
    }
  }

  Future<SearchResult<Dogadjaj>> findVerified({dynamic filter}) async {
    var url = "${_baseUrl}Dogadjaji/find-verified";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();
    print("my url is $url");

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<Dogadjaj>();
      result.count = data["count"];

      for (var item in data["result"]) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unknown exception");
    }
  }

  Future<Dogadjaj> sendRequestForTickets(int id, dynamic req) async {
    var url = "${_baseUrl}Dogadjaji/$id/send-ticket-request";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    print("my url is $url");
    print("ono sto dobijem $req");

    // String body = jsonEncode(req.map((item) => item.toJson()).toList());
    var jsonRequest = jsonEncode(req);
    print("ovo saljem $jsonRequest");
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown exception");
    }
  }

  Future<DogadjajiReportResponse> getReportData({dynamic filter}) async {
    var url = "${_baseUrl}Dogadjaji/report";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = reportfromJson(data);

      return result;
    } else {
      throw new Exception("Unknown exception");
    }
  }

  @override
  Dogadjaj fromJson(data) {
    return Dogadjaj.fromJson(data);
  }

  DogadjajiReportResponse reportfromJson(data) {
    return DogadjajiReportResponse.fromJson(data);
  }
}
