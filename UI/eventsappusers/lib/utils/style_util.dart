//buttons
import 'package:flutter/material.dart';

var buttonPrimary = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(Colors.blue),
  foregroundColor: WidgetStateProperty.all(Colors.white),
);

var buttonSecondary = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(Colors.white),
  foregroundColor: WidgetStateProperty.all(Colors.blue),
);

var paragaph = TextStyle(
  color: Color.fromRGBO(60, 71, 92, 1),
  fontSize: 12,
  letterSpacing: 0.3,
  fontFamily: 'Montserrat',
);

var inputField = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hoverColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide:
          const BorderSide(color: Color.fromRGBO(239, 239, 239, 1), width: 0.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.red),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0));
