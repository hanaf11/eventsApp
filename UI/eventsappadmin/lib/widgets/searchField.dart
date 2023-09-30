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
      child: Row(children: [
        Text(
          name,
          style: TextStyle(
              color: Color.fromRGBO(34, 33, 33, 1),
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(child: field),
        clearable != null
            ? IconButton(
                onPressed: () {
                  clearable?.clear(field);
                },
                icon: const Icon(Icons.clear),
                color: Colors.grey,
                splashRadius: 10,
              )
            : SizedBox(width: 10),
        SizedBox(
          width: 50,
        ),
      ]),
    );
  }
}

abstract class Clearable {
  void clear(Widget field);
}
