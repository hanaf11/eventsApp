import 'dart:convert';
import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/narudzba.dart';
import 'package:eventsappusers/models/validtipkarte.dart';
import "package:http/http.dart" as http;

import 'base_provider.dart';

class NarudzbaProvider extends BaseProvider<Narudzba> {
  static String? _baseUrl;
  static String? _endpoint;

  NarudzbaProvider() : super("Narudzba") {
    _endpoint = "Narudzba";
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7294/");
  }

  Future<List<ValidTipKarte>> validateRequest(dynamic request) async {
    var url = "$_baseUrl$_endpoint/validate-request";
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    request = request.map((key, value) => MapEntry(key.toString(), value));
    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<ValidTipKarte> result = [];
      for (var item in data) {
        result.add(fromJsonValidTipKarte(item));
      }

      return result;
    } else {
      throw Exception("Unknown exception");
    }
  }

  Future<Narudzba> createNarudzba(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);

      Narudzba result = fromJson(data);
      return result;
    } else {
      throw Exception("Unknown exception");
    }
  }

  Future<List<Dogadjaj>> getNarudzbeByKorisnik(dynamic filter) async {
    var url = "$_baseUrl$_endpoint/narudzbe-by-korisnik";
    var queryString = BaseProvider.getQueryString(filter);
    url = "$url?$queryString";

    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    var response = await http.get(uri, headers: headers);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<Dogadjaj> result = [];
      for (var item in data) {
        result.add(fromJsonDogadjaj(item));
      }
      return result;
    } else {
      throw Exception("Unknown exception");
    }
  }

  Future<String> createPaymentIntent(dynamic request) async {
    var url = "$_baseUrl$_endpoint/payment-intent";
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    request = request.map((key, value) => MapEntry(key.toString(), value));
    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (BaseProvider.isValidResponse(response)) {
      var data = response.body;
      return data;
    } else {
      throw Exception("Unknown exception");
    }
  }

  ValidTipKarte fromJsonValidTipKarte(data) {
    return ValidTipKarte.fromJson(data);
  }

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }

  Dogadjaj fromJsonDogadjaj(data) {
    return Dogadjaj.fromJson(data);
  }
}
