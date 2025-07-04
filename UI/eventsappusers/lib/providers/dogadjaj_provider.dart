import 'dart:convert';
import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/kategorija.dart';
import 'package:eventsappusers/models/search_result.dart';
import 'package:eventsappusers/providers/auth_provider.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart';

import 'base_provider.dart';

class DogadjajProvider extends BaseProvider<Dogadjaj> {
  static String? _baseUrl;
  static String? _endpoint;
  DogadjajProvider() : super("Dogadjaji") {
    _endpoint = "Dogadjaji";
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7294/");
  }

  Future<List<Dogadjaj>> getFollowing(int? korisnikId) async {
    var url = "$_baseUrl$_endpoint/$korisnikId/following-categories";
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

  Future<List<Dogadjaj>> getSaved(int? korisnikId) async {
    var url = "${_baseUrl}Saving/$korisnikId/saved";
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

  @override
  Dogadjaj fromJson(data) {
    return Dogadjaj.fromJson(data);
  }
}
