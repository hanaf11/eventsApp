import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InputFormField extends StatefulWidget {
  final Widget field;
  final String? label;
  final bool? multiline;
  InputFormField({super.key, required this.field, this.label, this.multiline});

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  _InputFormFieldState();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.label != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      widget.label!,
                      style: TextStyle(
                          color: Color.fromRGBO(60, 71, 92, 1),
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          letterSpacing: 0.3),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('')),
            Container(
              height: (widget.multiline != null && widget.multiline == true)
                  ? 100
                  : 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Color.fromRGBO(200, 200, 200, 1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(2, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(children: [
                  widget.field,
                ]),
              ),
            ),
          ],
        ));
  }
}
