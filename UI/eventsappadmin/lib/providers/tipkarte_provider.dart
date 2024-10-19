import 'dart:convert';

import 'package:eventsappadmin/models/dogadjaj.dart';
import 'package:eventsappadmin/models/search_result.dart';
import 'package:eventsappadmin/models/tipkarte.dart';
import 'package:eventsappadmin/providers/base_provider.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/kategorija.dart';

class TipkarteProvider extends BaseProvider<TipKarte> {
  TipkarteProvider() : super("TipKarte") {}

  @override
  TipKarte fromJson(data) {
    return TipKarte.fromJson(data);
  }
}
