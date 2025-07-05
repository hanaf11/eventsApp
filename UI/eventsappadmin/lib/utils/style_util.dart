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

    
  final TextStyle myTextStyle = TextStyle(
      color: Color.fromRGBO(60, 71, 92, 1),
      fontSize: 15,
      fontFamily: 'Montserrat',
      letterSpacing: 0.3);

  TextStyle boldStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 71, 70, 70),
        fontSize: 16,
      );     
