import 'dart:convert';

import 'package:eventsappusers/models/slika.dart';
import 'package:eventsappusers/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

List months = [
  'jan',
  'feb',
  'mar',
  'apr',
  'maj',
  'jun',
  'jul',
  'aug',
  'sep',
  'okt',
  'nov',
  'dec'
];

String formatNumber(dynamic) {
  var f = NumberFormat("###,00");
  if (dynamic == null) return "";
  return f.format(dynamic);
}

String printDate(DateTime date) {
  return date.day.toString() +
      ". " +
      date.month.toString() +
      ". " +
      date.year.toString() +
      ".";
}

String formatDate(DateTime date) {
  return date.day.toString() +
      ". " +
      months[date.month - 1] +
      " " +
      date.year.toString() +
      ".";
}

String dayAndMonth(DateTime date) {
  return date.day.toString() + ". " + months[date.month - 1];
}

String printTime(TimeOfDay time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}

ImageProvider imageProviderFromBase64String(String? base64Image) {
  if (base64Image != null) {
    try {
      return MemoryImage(
        base64Decode(base64Image),
      );
    } on Exception catch (e) {
      return AssetImage('assets/images/no_picture.jpg');
    }
  }
  return AssetImage('assets/images/no_picture.jpg');
}

Image imageFromBase64String(String? base64Image) {
  if (base64Image != null && base64Image.isNotEmpty) {
    try {
      return Image.memory(
        base64Decode(base64Image),
        fit: BoxFit.cover,
      );
    } on Exception catch (e) {
      return Image.asset(
        'assets/images/no_picture.jpg',
        fit: BoxFit.cover,
      );
    }
  }
  return Image.asset('assets/images/no_picture.jpg', fit: BoxFit.cover);
}

MemoryImage getDecorationImage(String base64Image) {
  return MemoryImage(base64Decode(base64Image));
}

List<ImageObj>? imageListFromBase64String(List<Slika>? galerija) {
  if (galerija == null || galerija.isEmpty) {
    print("galerija null ili empty");
    return null;
  }

  List<ImageObj> imageList = [];
  galerija.forEach((img) => imageList
      .add(new ImageObj(imageFromBase64String(img.slika), img.slika!)));
  return imageList;
}
