import 'dart:convert';
import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'base_provider.dart';

class RecommenderProvider with ChangeNotifier {
  static String? _baseUrl;
  final String _endpoint = "RecommenderSystem";

  RecommenderProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7294/");
  }

  Future<List<Dogadjaj>> recommend(int korisnikId) async {
    var url = "$_baseUrl$_endpoint/$korisnikId";
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    var response = await http.get(uri, headers: headers);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<Dogadjaj> result = [];
      for (var item in data) {
        result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Unknown exception");
    }
  }

  Dogadjaj fromJson(data) {
    return Dogadjaj.fromJson(data);
  }
}
