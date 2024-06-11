import 'dart:convert';
import 'package:eventsappusers/models/kategorija.dart';
import 'package:eventsappusers/providers/auth_provider.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart';

import 'base_provider.dart';

class KategorijeProvider extends BaseProvider<Kategorija> {
  KategorijeProvider() : super("Kategorije");

  @override
  Kategorija fromJson(data) {
    return Kategorija.fromJson(data);
  }
}
