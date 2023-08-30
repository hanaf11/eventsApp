import 'dart:convert';

import 'package:eventsappadmin/models/dogadjaj.dart';
import 'package:eventsappadmin/models/search_result.dart';
import 'package:eventsappadmin/providers/base_provider.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/kategorija.dart';

class KategorijaProvider extends BaseProvider<Kategorija> {
  KategorijaProvider() : super("Kategorije") {}

  @override
  Kategorija fromJson(data) {
    return Kategorija.fromJson(data);
  }
}
