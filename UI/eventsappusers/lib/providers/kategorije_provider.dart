import 'dart:convert';
import 'package:eventsappusers/providers/auth_provider.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart';

class KategorijeProvider {
  static String? _baseUrl;
  KategorijeProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7294/");
  }

  Future<dynamic> get() async {
    print("zsk");
    var url = "${_baseUrl}Kategorije";
    var uri = Uri.parse(url);

    var response = await http.get(uri, headers: createHeaders());

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      new Exception("Unknown response");
    }
  }

  bool isValidResponse(Response response) {
    print("provjeravam validnost ${response.statusCode}");
    if (response.statusCode < 299) return true;
    if (response.statusCode == 400)
      throw new Exception("Unauthorized");
    else {
      throw new Exception("Something bad happened. Please try again");
    }
  }

  Map<String, String> createHeaders() {
    String username = AuthProvider.username ?? "";
    String password = AuthProvider.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode("$username:$password"))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    return headers;
  }
}
