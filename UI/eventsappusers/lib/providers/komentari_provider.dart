import 'dart:convert';
import 'package:eventsappusers/models/komentar.dart';
import 'package:eventsappusers/models/search_result.dart';
import "package:http/http.dart" as http;

import 'base_provider.dart';

class KomentariProvider extends BaseProvider<Komentar> {
  static String? _baseUrl;
  static String? _endpoint;

  KomentariProvider() : super("Komentari") {
    _endpoint = "Komentari";
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7294/");
  }

  Future<SearchResult<Komentar>> post(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<Komentar>();
      result.count = data["count"];

      for (var item in data["result"]) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unknown exception");
    }
  }

  @override
  Komentar fromJson(data) {
    return Komentar.fromJson(data);
  }
}
