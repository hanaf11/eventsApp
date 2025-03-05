import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final Future<dynamic> Function() onClick;
  final bool deleted;
  final String text;

  const ButtonWidget(
      {super.key,
      required this.onClick,
      required this.deleted,
      required this.text});

  @override
  ButtonWidgetState createState() => ButtonWidgetState();
}

class ButtonWidgetState extends State<ButtonWidget> {
  bool _isFetching = false;
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    _isDeleted = widget.deleted;
  }

  void fetchingTrue() {
    setState(() {
      _isFetching = true;
    });
  }

  void fetchingFalse() {
    setState(() {
      _isFetching = false;
    });
  }

  void setDeleted(bool value) {
    setState(() {
      _isDeleted = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: _isDeleted
                  ? Color.fromARGB(255, 90, 79, 81)
                  : (widget.text == "Odbij" || widget.text == "Obriši")
                      ? Color.fromARGB(255, 198, 28, 53)
                      : Color.fromARGB(255, 16, 104, 198)),
          onPressed: _isDeleted
              ? null
              : () {
                  widget.onClick();
                },
          child: _isFetching
              ? const CircularProgressIndicator()
              : Text(
                  widget.text,
                  style: TextStyle(color: Colors.white),
                ),
        ));
  }
}
