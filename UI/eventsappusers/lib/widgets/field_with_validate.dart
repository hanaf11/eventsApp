import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FieldWithValidate extends StatelessWidget {
  final String label;
  final Widget field;

  FieldWithValidate({
    required this.field,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (optional)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            label,
            style: TextStyle(
                color: Color.fromRGBO(60, 71, 92, 1),
                fontFamily: 'Montserrat',
                fontSize: 15,
                letterSpacing: 0.3),
          ),
        ),
        // Container for the input field
        // SizedBox(height: 60, child: field)
        field
      ],
    );
  }
}
