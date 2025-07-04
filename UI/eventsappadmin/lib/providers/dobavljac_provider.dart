import 'dart:convert';

import 'package:eventsappadmin/models/dobavljac.dart';
import 'package:eventsappadmin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class DobavljacProvider extends BaseProvider<Dobavljac> {
  static String? _baseUrl;
  DobavljacProvider() : super("Dobavljaci") {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7294/");
  }

  @override
  Dobavljac fromJson(data) {
    return Dobavljac.fromJson(data);
  }

  Future<Dobavljac> changeStatus(int id, bool status) async {
    var url = "${_baseUrl}Dobavljaci/${id}/change-status";
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    var jsonRequest = jsonEncode(status);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown exception");
    }
  }
}
