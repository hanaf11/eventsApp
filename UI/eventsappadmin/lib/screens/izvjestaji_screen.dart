import 'dart:ffi';

import 'package:eventsappadmin/screens/dogadjaj_izvjestaj_screen.dart';
import 'package:eventsappadmin/screens/korisnici_izvjestaj_screen.dart';
import 'package:eventsappadmin/screens/narudzbe_izvjestaj_screen.dart';
import 'package:eventsappadmin/utils/style_util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class IzvjestajiScreen extends StatefulWidget {
  int? selected = 6;
  IzvjestajiScreen({this.selected, super.key});

  @override
  State<IzvjestajiScreen> createState() => _IzvjestajiScreenState();
}

class _IzvjestajiScreenState extends State<IzvjestajiScreen> {
  int? selected;
  final List<String> _items = [
    "Događaji",
    "Korisnici",
    "Narudžbe",
  ];
  int _selectedCard = -1;
  final Map<int, List<String>> _optionsData = {
    0: [
      "Broj događaja po statusima",
      "Broj događaja po kategorijama",
      "Top 3 događaja s najvećim prihodom",
      "Top 3 događaja s najviše pregleda",
      "Top 3 najviše sačuvanih događaja"
    ],
    1: [
      "Broj registrovanih korisnika u zadnjih mjesec dana",
      "Top 3 korisnika s najviše narudžbi",
      "Top 3 najaktivnijih korisnika",
      "Top 3 kategorije događaja prema broju pratilaca"
    ],
    2: [
      "Broj narudžbi u zadnjih mjesec dana",
      "Zarada u zadnjih mjesec dana",
      "Broj prodanih karata u zadnjih mjesec dana",
      "Top 3 događaja s najviše prodanih karata",
    ],
  };
  List<bool> optionsValues = [];
  List<String> _selectedReports = [];

  _IzvjestajiScreenState();

  void _onItemTapped(int index) {
    setState(() {
      _selectedCard = index;
      optionsValues =
          List<bool>.filled(_optionsData[_selectedCard]?.length ?? 0, false);
      _selectedReports = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: widget.selected,
        child: Expanded(
            child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(vertical: 5),
                child: SingleChildScrollView(
                    child: Column(
                  children: [_buildCardMenu(), _buildOptions()],
                )))));
  }

  Row _buildCardMenu() {
    return Row(
        children: List.generate(_items.length, (index) {
      final item = _items[index];
      return Expanded(
          child: Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(241, 241, 241, 1),
                      border: Border.all(
                          color: _selectedCard == index
                              ? Color.fromRGBO(4, 53, 201, 1)
                              : Color.fromRGBO(44, 152, 240, 1),
                          width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        item,
                        style: TextStyle(
                            color: _selectedCard == index
                                ? Color.fromRGBO(4, 53, 201, 1)
                                : Color.fromRGBO(44, 152, 240, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  onTap: () => _onItemTapped(index))));
    }));
  }

  getReportScreen() {
    switch (_selectedCard) {
      case 0:
        return DogadjajIzvjestajScreen(
          options: optionsValues,
        );
      case 1:
        return KorisniciIzvjestajScreen(
          options: optionsValues,
        );
      case 2:
        return NarudzbeIzvjestajScreen(options: optionsValues);
    }
  }

  Widget _buildOptions() {
    final options = _optionsData[_selectedCard] ?? [];

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(options.length, (index) {
                final option = options[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: CheckboxListTile(
                      title: Text(option),
                      value: optionsValues[index],
                      onChanged: (bool? value) {
                        setState(() {
                          optionsValues[index] = value!;
                          if (value == true) {
                            _selectedReports.add(option);
                          } else {
                            _selectedReports.remove(option);
                          }
                        });
                      }),
                );
              }),
            ),
            _optionsData[_selectedCard] != null
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: ElevatedButton(
                            style: buttonPrimary,
                            onPressed: () {
                              if (_selectedReports.isEmpty) {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Exception'),
                                    content: Text(
                                        "Morate odabrati bar jednu stavku izvještaja"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => getReportScreen()),
                                );
                              }
                            },
                            child: Text("Generiši"))))
                : Container()
          ],
        ));
  }
}
