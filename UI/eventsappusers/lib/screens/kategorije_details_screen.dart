import 'package:eventsappusers/widgets/dogadjaj_horizontal.dart';
import 'package:eventsappusers/widgets/podkategorije_tile.dart';
import 'package:flutter/material.dart';

import '../widgets/heading_widget.dart';
import '../widgets/input_field.dart';
import '../widgets/master_screen.dart';

class KategorijeDetailsScreen extends StatefulWidget {
  int kategorijaId;
  KategorijeDetailsScreen({super.key, required this.kategorijaId});

  @override
  State<KategorijeDetailsScreen> createState() =>
      _KategorijeDetailsScreenState();
}

class _KategorijeDetailsScreenState extends State<KategorijeDetailsScreen>
    implements Clearable {
  int? selectedPodkategorija = -1;
  late TextEditingController _datumOdController;
  late TextEditingController _datumDoController;
  bool locationFilter = false;
  DateTime? _datumOd;
  DateTime? _datumDo;
  _KategorijeDetailsScreenState();

  List<String> podkategorije = [
    "Finansije",
    "IT",
    "Menadžment",
    "Zdravstvo",
    "Ekologija",
    "Welness"
  ];

  void _handleSelection(int index) {
    setState(() {
      selectedPodkategorija = index;
      print("selected kategorija  ${index}");
    });
  }

  void _showDatePicker(caller) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        if (caller == "_datumOd") {
          _datumOd = value;
        } else {
          _datumDo = value;
        }
      });
    });
  }

  @override
  clear(dynamic input) {
    if (input is TextField) {
      if (input.key != null) {
        String keyName = input.key!.toString().replaceAll(RegExp(r"[<'>]"), '');
        keyName = keyName.substring(1, keyName.length - 1);
        if (keyName == '_datumOd') {
          setState(() {
            _datumOd = null;
          });
        }
        if (keyName == '_datumDo') {
          setState(() {
            _datumDo = null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    return MasterScreen(
        selectedIndex: 0,
        showBackButton: true,
        showFollowButton: true,
        child: Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      HeadingWidget(text: "Konferencije"),
                      /* Container(
                        height: 10,
                      ),*/
                      _buildFilters(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildDogadjajiTiles()
                    ],
                  )));
  }

  Widget _buildFilters() {
    return Column(
      children: [
        _buildPodkategorijeList(),
        _buildDateSearch(),
        _buildLocationCheckbox()
      ],
    );
  }

  Container _buildPodkategorijeList() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15.0),
      height: 35,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(podkategorije.length, (index) {
            return PodkategorijaTile(
                text: podkategorije[index],
                isSelected: selectedPodkategorija == index,
                onSelect: (isSelected) =>
                    {_handleSelection(isSelected ? index : -1)});
          })),
    );
  }

  Widget _buildDateSearch() {
    return Container(
        //  color: Colors.yellow,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 33,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                controller:
                    // TextEditingController(text: _datumOd.toString()),
                    _datumOdController = TextEditingController(
                        text: _datumOd == null
                            ? ""
                            : "${_datumOd?.day}.${_datumOd?.month}.${_datumOd?.year}."),
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
                controller:
                    // TextEditingController(text: _datumOd.toString()),
                    _datumDoController = TextEditingController(
                        text: _datumDo == null
                            ? ""
                            : "${_datumDo?.day}.${_datumDo?.month}.${_datumDo?.year}."),
                readOnly: true,
                key: const Key("_datumDo"),
                onTap: () {
                  _showDatePicker("_datumDo");
                },
              ),
              clearable: this,
            ),
          ],
        ));
  }

  CheckboxListTile _buildLocationCheckbox() {
    return CheckboxListTile(
      title: const Text(
        "Filtriraj najbliže meni",
        style: TextStyle(
            color: Color.fromRGBO(68, 68, 68, 1),
            fontSize: 14,
            letterSpacing: 0.3,
            fontFamily: 'Montserrat'),
      ),
      value: locationFilter,
      onChanged: (newValue) {
        setState(() {
          locationFilter = !locationFilter;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  _buildDogadjajiTiles() {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          DogadjajHorizontalWidget(
            naslov: "Test naslov",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Spanija",
          ),
          DogadjajHorizontalWidget(
            naslov:
                "TBosnian pyramids show in pyramid valley in visoko pls come hey hi hello hahaahha",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Visoko, BIH",
          ),
          DogadjajHorizontalWidget(
            naslov: "Queen tribute",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Sarajevo, BiH",
          ),
          DogadjajHorizontalWidget(
            naslov: "Test naslov",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Spanija",
          ),
          DogadjajHorizontalWidget(
            naslov: "Test naslov",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Spanija",
          ),
          DogadjajHorizontalWidget(
            naslov: "Test naslov",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Spanija",
          ),
        ],
      ),
    );
  }
}
