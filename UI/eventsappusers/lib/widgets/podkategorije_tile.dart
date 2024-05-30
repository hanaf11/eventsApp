import 'package:flutter/material.dart';

class PodkategorijaTile extends StatefulWidget {
  String text;
  bool isSelected;
  final Function(bool) onSelect;
  PodkategorijaTile(
      {required this.text,
      required this.isSelected,
      required this.onSelect,
      super.key});

  @override
  State<PodkategorijaTile> createState() => _PodkategorijaTileState();
}

class _PodkategorijaTileState extends State<PodkategorijaTile> {
  _PodkategorijaTileState();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.onSelect(!widget.isSelected);
          //   print("selected " + text);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: widget.isSelected
                      ? const Color.fromRGBO(44, 152, 240, 1)
                      : const Color.fromRGBO(178, 173, 173, 1)),
              color: widget.isSelected
                  ? const Color.fromRGBO(208, 227, 244, 1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(15)),
          child: Text(
            widget.text,
            style: const TextStyle(
                color: Color.fromRGBO(68, 68, 68, 1),
                fontSize: 12,
                letterSpacing: 0.3,
                fontFamily: 'Montserrat'),
          ),
        ));
  }
}
