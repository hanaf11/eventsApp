import 'dart:convert';

import 'package:eventsappadmin/models/narudzba.dart';
import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/providers/narudzba_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/style_util.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../providers/korisnik_provider.dart';
import '../widgets/searchField.dart';

class NarudzbeListScreen extends StatefulWidget {
  int? selected = 3;
  NarudzbeListScreen({this.selected, super.key});

  @override
  State<NarudzbeListScreen> createState() => _NarudzbeListScreenState(selected);
}

class _NarudzbeListScreenState extends State<NarudzbeListScreen>
    implements Clearable {
  int? selected;
  bool isLoading = true;
  final TextEditingController _brNarudzbeController =
      new TextEditingController();
  final TextEditingController _usernameController = new TextEditingController();
  late TextEditingController _datumController;
  late NarudzbaProvider _narudzbaProvider;
  SearchResult<Narudzba>? result;
  Narudzba? narudzba;
  DateTime? _datum;

  _NarudzbeListScreenState(this.selected);

  @override
  void initState() {
    super.initState();
    _narudzbaProvider = context.read<NarudzbaProvider>();
    getNarudzbe();
  }

  @override
  clear(dynamic input) {
    if (input is TextField) {
      if (input.key != null) {
        setState(() {
          _datum = null;
        });
      } else {
        input.controller!.text = "";
      }
    }
  }

  getNarudzbe() async {
    var data = await _narudzbaProvider.get(filter: {'OrderBy': '-Datum'});
    setState(() {
      result = data;
      isLoading = false;
    });
    print(result?.result);
  }

  search() async {
    var data = await _narudzbaProvider.get(filter: {
      'Username': _usernameController.text,
      'BrojNarudzbe': _brNarudzbeController.text,
      'Datum': _datum
    });

    setState(() {
      result = data;
    });
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    ).then((value) {
      setState(() {
        _datum = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: selected,
        child: isLoading
            ? Expanded(
                child: Container(
                    child: Center(child: const CircularProgressIndicator())))
            : Expanded(
                child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        _buildSearch(),
                        _buildDataListView(),
                      ],
                    )))));
  }

  Widget _buildSearch() {
    return Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  InputField(
                    name: "Broj narudžbe:",
                    field: TextField(
                      controller: _brNarudzbeController,
                    ),
                    clearable: this,
                  ),
                  InputField(
                    name: "Datum:",
                    field: TextField(
                      controller: _datumController = TextEditingController(
                          text: _datum == null
                              ? ""
                              : "${_datum?.day}.${_datum?.month}.${_datum?.year}."),
                      readOnly: true,
                      key: const Key("_datum"),
                      onTap: () {
                        _showDatePicker();
                      },
                    ),
                    clearable: this,
                  ),
                ],
              ),
              Row(
                children: [
                  InputField(
                    name: "Korisnik:",
                    field: TextField(
                      controller: _usernameController,
                    ),
                    clearable: this,
                  ),
                  InputField(
                    name: "",
                    field: ElevatedButton(
                      child: Text("Pretraga"),
                      style: buttonPrimary,
                      onPressed: () async {
                        search();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildDataListView() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
            ),
            child: DataTable(
                columns: [
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Broj narudžbe',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Datum',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Korisnik',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Cijena',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Detalji',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
                rows: result?.result
                        .map((Narudzba e) => DataRow(cells: [
                              DataCell(Text(
                                e.brojNarudzbe.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(
                                  "${e.datum.day}.${e.datum.month}.${e.datum.year}.")),
                              DataCell(Text(e.korisnickoIme)),
                              DataCell(Text(formatCijena(e.cijena))),
                              DataCell(IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  color: Color.fromRGBO(44, 152, 240, 1),
                                  splashRadius: 20,
                                  hoverColor: Color.fromRGBO(224, 224, 224, 1),
                                  onPressed: () {
                                    /*setState(() {
                                      isLoading = true;
                                    });

                                    _korisnikProvider
                                        .getById(e.korisnikId)
                                        .then((value) {
                                      setState(() {
                                        isLoading = false;
                                        korisnik = value;
                                      });
                                      _buildKorisnikDetails(korisnik);
                                    });*/
                                  })),
                            ]))
                        .toList() ??
                    []),
          ));
    });
  }

  _buildKorisnikDetails(Korisnik? k) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Detalji o korisniku', style: h2),
              content: isLoading
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 80,
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: k != null
                                          ? _buildProfilna(k.slika)
                                          : Image.asset(
                                              "assets/images/blankprofile.jpg",
                                              fit: BoxFit.cover))),
                              Container(
                                  width: 250,
                                  alignment: Alignment.topLeft,
                                  //color: Colors.red,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${k?.ime} ${k?.prezime}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 71, 70, 70),
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text("@${k?.korisnickoIme}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 90, 89, 89),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300)),
                                      Text("${k?.email}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300))
                                    ],
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Adresa:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 71, 70, 70),
                                                fontSize: 16)),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text("${k?.adresa}, ${k?.drzava}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                                fontSize: 16))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Telefon:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 71, 70, 70),
                                                fontSize: 16)),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text("${k?.telefon}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                                fontSize: 16))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Status:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 71, 70, 70),
                                                fontSize: 16)),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            k?.status == true
                                                ? "Aktivan"
                                                : "Deaktiviran",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                                fontSize: 16))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Račun kreiran:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 71, 70, 70),
                                                fontSize: 16)),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            "${k?.created.day}.${k?.created.month}.${k?.created.year}.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                                fontSize: 16))
                                      ],
                                    )
                                  ])
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Narudžbe",
                                      textAlign: TextAlign.start, style: h2),
                                  const Divider(
                                    color: Color.fromARGB(255, 145, 145, 145),
                                    height: 5,
                                    thickness: 0.7,
                                  ),
                                  k?.narudzbes == null || k!.narudzbes!.isEmpty
                                      ? const Text(
                                          "Korisnik nije izvršio nijednu narudžbu.",
                                          textAlign: TextAlign.left,
                                        )
                                      : const Text("ima nesto")
                                ]),
                          ])
                        ],
                      )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Zatvori'),
                  child: const Text('Zatvori'),
                ),
              ],
            ));
  }

  Image _buildProfilna(String? img) {
    if (img == null || img == "") {
      return Image.asset('assets/images/blankprofile.jpg', fit: BoxFit.cover);
    } else {
      try {
        Image slika = Image.memory(base64Decode(img), fit: BoxFit.cover);
        return slika;
      } on Exception catch (e) {
        return Image.asset('assets/images/blankprofile.jpg', fit: BoxFit.cover);
      }
    }
  }
}
