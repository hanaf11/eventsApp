import 'dart:convert';
import 'package:eventsappusers/models/slika.dart';
import 'package:eventsappusers/utils/util.dart';
import 'package:flutter/material.dart';
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
  var f = NumberFormat("###.00");
  if (dynamic == null) return "";
  return "${f.format(dynamic)}KM";
}

String printDate(DateTime date) {
  return "${date.day}. ${date.month}. ${date.year}.";
}

String formatDate(DateTime date) {
  return "${date.day}. " +
      months[date.month - 1] +
      " " +
      date.year.toString() +
      ".";
}

String dayAndMonth(DateTime date) {
  return "${date.day}. " + months[date.month - 1];
}

ImageProvider imageProviderFromBase64String(String? base64Image) {
  if (base64Image != null) {
    try {
      return MemoryImage(
        base64Decode(base64Image),
      );
    } on Exception {
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
    } on Exception {
      return Image.asset(
        'assets/images/no_picture.jpg',
        fit: BoxFit.cover,
      );
    }
  }
  return Image.asset('assets/images/no_picture.jpg', fit: BoxFit.cover);
}

List<ImageObj>? imageListFromBase64String(List<Slika>? galerija) {
  if (galerija == null || galerija.isEmpty) {
    return null;
  }

  List<ImageObj> imageList = [];
  for (var img in galerija) {
    imageList
      .add(ImageObj(imageFromBase64String(img.slika), img.slika!));
  }
  return imageList;
}
