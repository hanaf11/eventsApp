import 'dart:convert';

import 'package:eventsappusers/models/tipkarte.dart';
import 'package:eventsappusers/providers/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/kategorija.dart';

class TipkarteProvider extends BaseProvider<TipKarte> {
  TipkarteProvider() : super("TipKarte");

  @override
  TipKarte fromJson(data) {
    return TipKarte.fromJson(data);
  }
}
