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
          const BorderSide(color: Color.fromRGBO(195, 196, 198, 1), width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide:
          BorderSide(color: Color.fromRGBO(195, 196, 198, 1), width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide:
          BorderSide(color: Color.fromRGBO(195, 196, 198, 1), width: 0.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide:
          BorderSide(color: Color.fromRGBO(195, 196, 198, 1), width: 0.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.red),
    ),
    constraints: BoxConstraints(minHeight: 30),
    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    errorMaxLines: 1);

var newInput = InputDecoration(
    filled: true,
    fillColor: Color.fromRGBO(245, 245, 245, 1),
    hoverColor: Color.fromRGBO(245, 245, 245, 1),
    isDense: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide:
          const BorderSide(color: Color.fromRGBO(54, 112, 232, 1), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide:
          const BorderSide(color: Color.fromRGBO(54, 112, 232, 1), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide:
          const BorderSide(color: Color.fromRGBO(54, 112, 232, 1), width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.red),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8));
