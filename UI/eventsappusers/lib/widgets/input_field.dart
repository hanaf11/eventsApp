import 'package:flutter/material.dart';
import '../utils/util.dart';

class InputField extends StatelessWidget {
  String name;
  Widget field;
  Clearable? clearable;
  InputField(
      {super.key, required this.name, required this.field, this.clearable});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            //padding: EdgeInsets.symmetric(horizontal: 10),
            // color: Colors.red,
            child: Row(children: [
      Text(
        name,
        style: TextStyle(
            color: Color.fromRGBO(34, 33, 33, 1), fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 8,
      ),
      Expanded(
        child: Container(
            padding: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  width: 1,
                  color: const Color.fromRGBO(178, 173, 173, 1),
                )),
            child: Row(
              children: [
                Expanded(child: field),
                clearable != null
                    ? Container(
                        child: IconButton(
                        onPressed: () {
                          clearable?.clear(field);
                        },
                        icon: const Icon(Icons.clear),
                        iconSize: 15,
                        color: Colors.grey,
                        splashRadius: 10,
                      ))
                    : SizedBox(width: 10),
              ],
            )),
      )
    ])));
  }
}

abstract class Clearable {
  void clear(Widget field);
}
