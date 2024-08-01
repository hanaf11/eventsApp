import 'dart:convert';
import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/kategorija.dart';
import 'package:eventsappusers/models/korisnik.dart';
import 'package:eventsappusers/models/search_result.dart';
import 'package:eventsappusers/providers/auth_provider.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart';

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

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }
}
