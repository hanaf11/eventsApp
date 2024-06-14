import 'dart:convert';

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

String printTime(TimeOfDay time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}
