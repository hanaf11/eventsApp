import 'package:flutter/material.dart';

class ListInputWidget extends StatefulWidget {
  List<String> valueList;
  String? label;
  ValueChanged<String?>? onChanged;

  ListInputWidget(
      {required this.valueList, this.label, this.onChanged, super.key});

  @override
  State<ListInputWidget> createState() => _ListInputWidgetState();
}

class _ListInputWidgetState extends State<ListInputWidget> {
  String? _currentSelectedValue;
  _ListInputWidgetState();

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  : Container(),
              Container(
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
                  child: InputDecorator(
                      decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: 35),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 164, 163, 163),
                              fontSize: 11.0),
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 11.0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20.0))),
                      isEmpty: _currentSelectedValue == '-',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          value: _currentSelectedValue,
                          isDense: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentSelectedValue =
                                  newValue ?? _currentSelectedValue;
                              state.didChange(newValue);
                            });
                            if (widget.onChanged != null) {
                              widget.onChanged!(newValue); // Call the callback
                            }
                          },
                          items: widget.valueList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 88, 87, 87)),
                              ),
                            );
                          }).toList(),
                        ),
                      )))
            ]));
      },
    );
  }
}
