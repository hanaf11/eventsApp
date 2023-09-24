import 'dart:convert';

import '../models/slika.dart';
import 'base_provider.dart';

class GalerijaProvider extends BaseProvider<Slika> {
  GalerijaProvider() : super("Galerija") {}

  @override
  Slika fromJson(data) {
    return Slika.fromJson(data);
  }
}
