import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? placeholder;
  final String? type;
  final String? label;
  final bool? readOnly;

  InputWidget(
      {super.key,
      required this.controller,
      this.placeholder,
      this.type,
      this.readOnly,
      this.label});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  _InputWidgetState();

  @override
  Widget build(BuildContext context) {
    return /*Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child:*/
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.label ?? '',
                  style: TextStyle(
                      color: Color.fromRGBO(60, 71, 92, 1),
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      letterSpacing: 0.3),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 8), child: Text('')),
        Container(
            height: widget.type == 'multiline' ? 100 : 35,
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
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: widget.controller,
                keyboardType: _getType(),
                inputFormatters: widget.type == 'number'
                    ? <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]
                    : null,
                decoration: InputDecoration.collapsed(
                  hintText: widget.placeholder,
                ),
                minLines: 1,
                maxLines: widget.type == 'multiline' ? null : 1,
                readOnly: widget.readOnly != null && widget.readOnly == true
                    ? true
                    : false,
              ),
            )),
      ],
    )
        // )
        ;
  }

  _getType() {
    if (widget.type != null) {
      switch (widget.type) {
        case 'number':
          return TextInputType.number;
        case 'multiline':
          return TextInputType.multiline;
      }
    }
    return null;
  }
}
