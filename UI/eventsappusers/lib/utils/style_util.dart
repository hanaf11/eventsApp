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
