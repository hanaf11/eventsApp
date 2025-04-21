import 'dart:convert';

import 'package:eventsappadmin/models/stavke_narudzbe.dart';
import 'package:eventsappadmin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class StavkeNarudzbeProvider extends BaseProvider<StavkeNarudzbe> {
  static String? _baseUrl;
  StavkeNarudzbeProvider() : super("StavkeNarudzbe") {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7294/");
  }

  Future<List<StavkeNarudzbe>> getStavke({dynamic filter}) async {
    var url = "${_baseUrl}StavkeNarudzbe";
    if (filter != null) {
      var queryString = BaseProvider.getQueryString(filter);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = BaseProvider.createHeaders();

    var response = await http.get(uri, headers: headers);

    var result = <StavkeNarudzbe>[];

    if (BaseProvider.isValidResponse(response)) {
      var data = jsonDecode(response.body);

      for (var item in data) {
        result.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown exception");
    }
  }

  StavkeNarudzbe fromJson(data) {
    return StavkeNarudzbe.fromJson(data);
  }
}
