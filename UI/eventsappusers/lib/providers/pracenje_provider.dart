import 'dart:convert';
import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/kategorija.dart';
import 'package:eventsappusers/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart';

import 'base_provider.dart';

class PracenjeProvider with ChangeNotifier {
  static String? _baseUrl;
  final String _endpoint = "Pracenje";

  PracenjeProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7294/");
  }
  Future<bool> isFollowing(dynamic filter) async {
    var url = "$_baseUrl$_endpoint/is-following";
    var queryString = BaseProvider.getQueryString(filter);
    url = "$url?$queryString";

    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    print("this is my uri: ${uri}");

    var response = await http.get(uri, headers: headers);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw new Exception("Unknown exception");
    }
  }

  Future<bool> follow(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw new Exception("Unknown exception");
    }
  }

  Future<bool> unfollow(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.delete(uri, headers: headers, body: jsonRequest);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw new Exception("Unknown exception");
    }
  }
}
