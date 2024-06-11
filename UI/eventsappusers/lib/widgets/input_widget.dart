import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final String? type;

  InputWidget(
      {super.key,
      required this.controller,
      required this.placeholder,
      this.type});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  _InputWidgetState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Container(
          height: 35,
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
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                    controller: widget.controller,
                    keyboardType:
                        widget.type != null ? TextInputType.number : null,
                    inputFormatters: widget.type == 'number'
                        ? <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ]
                        : null,
                    decoration: new InputDecoration.collapsed(
                      hintText: widget.placeholder,
                    )),
              )),
              /* Container(
                  child: IconButton(
                onPressed: () {
                  //   search();
                },
                icon: const Icon(Icons.search),
                iconSize: 25,
                color: Colors.black,
                splashRadius: 10,
              ))*/
            ],
          )),
    );
  }
}
