import 'package:eventsappusers/models/kategorija.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CategoryColorManager {
  CategoryColorManager._internal([List<Kategorija>? kategorijeList]) {
    if (kategorijeList != null) {
      _initializeCategoryColors(kategorijeList);
    }
  }

  static CategoryColorManager? _instance;

  factory CategoryColorManager([List<Kategorija>? kategorijeList]) {
    if (_instance == null) {
      return _instance = CategoryColorManager._internal(kategorijeList);
    } else {
      return _instance!;
    }
  }

  final Map<int, Color> _categoryColors = {};

  void _initializeCategoryColors(List<Kategorija> kategorijeList) {
    for (var k in kategorijeList) {
      if (!_categoryColors.containsKey(k.kategorijaId)) {
        _categoryColors[k.kategorijaId!] = _generateRandomColor();
      }
    }
  }

  Color getColorForCategory(int categoryId) {
    return _categoryColors[categoryId]!;
  }

  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
