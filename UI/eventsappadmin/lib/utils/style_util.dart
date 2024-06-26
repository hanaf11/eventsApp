import 'package:flutter/material.dart';

//buttons
var buttonPrimary = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(Colors.blue),
  foregroundColor: WidgetStateProperty.all(Colors.white),
);

var buttonSecondary = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(Colors.white),
  foregroundColor: WidgetStateProperty.all(Colors.blue),
);

//headings
var h2 = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(54, 112, 232, 1),
    letterSpacing: 0.4,
    fontSize: 24);
