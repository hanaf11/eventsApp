import 'dart:convert';
import 'package:eventsappusers/models/korisnik.dart';
import "package:http/http.dart" as http;

import 'base_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  static String? _baseUrl;
  static String? _endpoint;

  KorisnikProvider() : super("Korisnici") {
    _endpoint = "Korisnici";
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7294/");
  }

  Future<Korisnik> login(dynamic credentials) async {
    var url = "$_baseUrl$_endpoint/login";
    var queryString = BaseProvider.getQueryString(credentials);
    url = "$url?$queryString";
    var uri = Uri.parse(url);

    var headers = BaseProvider.createHeaders();

    var response = await http.get(uri, headers: headers);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown exception");
    }
  }

  Future<Korisnik> updateProfilePicture(int id, String image) async {
    var url = "$_baseUrl$_endpoint/$id/update-picture";
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    var jsonRequest = jsonEncode(image);

    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown exception");
    }
  }

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }
}
