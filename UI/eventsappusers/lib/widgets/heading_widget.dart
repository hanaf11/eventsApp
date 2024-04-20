import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String text;
  const HeadingWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: const TextStyle(
            color: Color.fromRGBO(60, 71, 92, 1),
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'Magra'),
        textAlign: TextAlign.center,
        child: Text(text));
  }
}
