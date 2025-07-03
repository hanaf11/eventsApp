import 'dart:convert';

import 'package:eventsappusers/providers/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/podkategorija.dart';

class PodkategorijaProvider extends BaseProvider<Podkategorija> {
  PodkategorijaProvider() : super("Podkategorije");

  @override
  Podkategorija fromJson(data) {
    return Podkategorija.fromJson(data);
  }
}
