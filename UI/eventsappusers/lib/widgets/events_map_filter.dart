import 'package:eventsappusers/models/kategorija.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:eventsappusers/widgets/input_field.dart';
import 'package:flutter/material.dart';

class EventsMapFilter extends StatefulWidget {
  final TextEditingController searchController;
  final int? kategorijaSelected;
  final List<Kategorija> kategorijeList;
  final VoidCallback onFilterTap;
  final Function(int?) onKategorijaSelected;
  final TextEditingController datumOdController;
  final TextEditingController datumDoController;
  final DateTime? datumOd;
  final DateTime? datumDo;
  final Function(DateTime?, String) onDateSelected;

  const EventsMapFilter(
      {super.key,
      required this.searchController,
      this.kategorijaSelected,
      required this.kategorijeList,
      required this.onFilterTap,
      required this.onKategorijaSelected,
      required this.datumOdController,
      required this.datumDoController,
      this.datumOd,
      this.datumDo,
      required this.onDateSelected});

  @override
  _EventsMapFilterState createState() => _EventsMapFilterState();
}

class _EventsMapFilterState extends State<EventsMapFilter>
    implements Clearable {
  late TextEditingController _searchController;
  late int? _kategorijaSelected;
  late List<Kategorija> _kategorijeList;
  late TextEditingController _datumOdController;
  late TextEditingController _datumDoController;
  late DateTime? _datumOd;
  late DateTime? _datumDo;
  /*  Future<void> _selectDate(BuildContext context, String field) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (field == 'datumOd') {
          _datumOdDateController.text = selectedDate.toLocal().toString().split(' ')[0];
        } else if (field == 'datumDo') {
          _datumDoDateController.text = selectedDate.toLocal().toString().split(' ')[0];
        }
      });
    }
  }*/

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController;
    _kategorijaSelected = widget.kategorijaSelected;
    _kategorijeList = widget.kategorijeList;
    _datumOd = widget.datumOd;
    _datumDo = widget.datumDo;
    _datumOdController = widget.datumOdController;
    _datumDoController = widget.datumDoController;
  }

  @override
  clear(dynamic input) {
    print(input);
    if (input is TextField) {
      if (input.key != null) {
        String keyName = input.key!.toString().replaceAll(RegExp(r"[<'>]"), '');
        keyName = keyName.substring(1, keyName.length - 1);
        if (keyName == '_datumOd') {
          setState(() {
            _datumOd = null;
            input.controller?.clear();
            widget.onDateSelected(null, keyName);
          });
        }
        if (keyName == '_datumDo') {
          setState(() {
            _datumDo = null;
            input.controller?.clear();
            widget.onDateSelected(null, keyName);
          });
        }
      } else {
        final controller = input.controller;
        if (controller != null) {
          controller.clear();
        }
      }
    } else if (input is FormField<int>) {
      setState(() {
        _kategorijaSelected = null;
      });
      widget.onKategorijaSelected(null);
    }
  }

  void _showDatePicker(caller) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime(2030))
        .then((value) {
      print("value $value");
      print("caller $caller");
      if (value != null) {
        setState(() {
          if (caller == "_datumOd") {
            _datumOd = value;
            _datumOdController.text = printDate(value);
            widget.onDateSelected(value, caller);
          } else {
            _datumDo = DateTime(value.year, value.month, value.day, 23, 59, 59);
            _datumDoController.text = printDate(value);
            print("novi datum do $_datumDo");
            widget.onDateSelected(value, caller);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filtriranje"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            InputField(
                field: TextField(
                  style: const TextStyle(
                      color: Color.fromRGBO(68, 68, 68, 1),
                      fontSize: 14,
                      letterSpacing: 0.3,
                      fontFamily: 'Montserrat'),
                  decoration:
                      InputDecoration.collapsed(hintText: 'Naziv događaja'),
                  controller: _searchController,
                ),
                clearable: this),
            _buildKategorija(),
            _buildDatePicker()
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Odustani"),
        ),
        TextButton(
          onPressed: () {
            widget.onFilterTap();
            Navigator.pop(context);
          },
          child: const Text("Filtriraj"),
        ),
      ],
    );
  }

  Column _buildKategorija() {
    return Column(children: [
      SizedBox(height: 5),
      InputField(
          field: FormField<int>(
            builder: (FormFieldState<int> state) {
              return Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: InputDecorator(
                      decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: 35),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(68, 68, 68, 1),
                              fontSize: 14,
                              letterSpacing: 0.3,
                              fontFamily: 'Montserrat'),
                          hintText: 'Kategorija',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                      isEmpty: _kategorijaSelected == null,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          value: _kategorijaSelected,
                          isDense: true,
                          onChanged: (int? newValue) {
                            setState(() {
                              _kategorijaSelected =
                                  newValue ?? _kategorijaSelected;
                              state.didChange(newValue);
                            });
                            widget.onKategorijaSelected(newValue);
                          },
                          items: _kategorijeList.map((Kategorija value) {
                            return DropdownMenuItem<int>(
                              value: value.kategorijaId,
                              child: Text(
                                value.naziv ?? '',
                                style: const TextStyle(
                                    color: Color.fromRGBO(68, 68, 68, 1),
                                    fontSize: 14,
                                    letterSpacing: 0.3,
                                    fontFamily: 'Montserrat'),
                              ),
                            );
                          }).toList(),
                        ),
                      )));
            },
          ),
          clearable: this),
    ]);
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        children: [
          InputField(
            name: "Od:",
            field: TextField(
              style: const TextStyle(
                  color: Color.fromRGBO(68, 68, 68, 1),
                  fontSize: 14,
                  letterSpacing: 0.3,
                  fontFamily: 'Montserrat'),
              decoration: InputDecoration.collapsed(hintText: 'Datum od'),
              controller: _datumOdController,
              readOnly: true,
              key: const Key("_datumOd"),
              onTap: () {
                _showDatePicker("_datumOd");
              },
            ),
            clearable: this,
          ),
          SizedBox(
            width: 10,
          ),
          InputField(
            name: "Do:",
            field: TextField(
              style: const TextStyle(
                  color: Color.fromRGBO(68, 68, 68, 1),
                  fontSize: 14,
                  letterSpacing: 0.3,
                  fontFamily: 'Montserrat'),
              decoration: InputDecoration.collapsed(hintText: 'Datum do'),
              controller: _datumDoController,
              readOnly: true,
              key: const Key("_datumDo"),
              onTap: () {
                _showDatePicker("_datumDo");
              },
            ),
            clearable: this,
          )
        ],
      ),
    );
  }

/*Widget _buildDatePicker() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, 'datumOd'),
                child: IgnorePointer(
                  child: TextField(
                    controller: _datumOdDateController,
                    decoration: const InputDecoration(labelText: 'Od:'),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, 'datumDo'),
                child: IgnorePointer(
                  child: TextField(
                    controller: _datumDoDateController,
                    decoration: const InputDecoration(labelText: 'Do:'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}*/
}
