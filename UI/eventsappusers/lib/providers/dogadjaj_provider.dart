import 'dart:convert';
import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/kategorija.dart';
import 'package:eventsappusers/providers/auth_provider.dart';
import "package:http/http.dart" as http;
import 'package:http/http.dart';

import 'base_provider.dart';

class DogadjajProvider extends BaseProvider<Dogadjaj> {
  DogadjajProvider() : super("Dogadjaji");

  @override
  Dogadjaj fromJson(data) {
    return Dogadjaj.fromJson(data);
  }
}
