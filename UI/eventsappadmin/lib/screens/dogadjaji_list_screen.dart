import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:eventsappadmin/widgets/searchField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/kategorija.dart';
import '../models/search_result.dart';
import '../providers/kategorija_provider.dart';
import '../widgets/searchField.dart';

class DogadjajiListScreen extends StatefulWidget {
  DogadjajiListScreen({super.key});

  @override
  State<DogadjajiListScreen> createState() => _DogadjajiListScreenState();
}

class _DogadjajiListScreenState extends State<DogadjajiListScreen>
    implements Clearable {
  int selected = 0;
  late DogadjajProvider _dogadjajProvider;
  late KategorijaProvider _kategorijaProvider;
  SearchResult<Dogadjaj>? result;
  int? _dropdownValue;
  SearchResult<Kategorija>? kategorijeResult;
  TextEditingController _ftsController = new TextEditingController();
  TextEditingController _lokacijaController = new TextEditingController();
  late TextEditingController _datumOdController;
  late TextEditingController _datumDoController;
  bool isLoading = true;
  bool backButtonEnabled = false;
  bool initial = true;
  DateTime? _datumOd;
  DateTime? _datumDo;

  @override
  void initState() {
    super.initState();
    _kategorijaProvider = context.read<KategorijaProvider>();
    _dogadjajProvider = context.read<DogadjajProvider>();
    initForm();
    getDogadjaji();
    /*_datumOdController = TextEditingController(text: _datumOd.toString());
    _datumDoController = TextEditingController(text: _datumDo.toString());*/
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //dropdownValue = kategorijeResult?.result[0].kategorijaId;
  }

  Future initForm() async {
    kategorijeResult = await _kategorijaProvider.get();
  }

  /*Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }*/

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

  getDogadjaji() async {
    var data = await _dogadjajProvider.get();
    setState(() {
      result = data;
      isLoading = false;
    });
  }

  search() async {
    var data = await _dogadjajProvider.get(filter: {
      'FTS': _ftsController.text,
      'Kategorija': _dropdownValue,
      'Lokacija': _lokacijaController.text,
      'DatumOd': _datumOd,
      'DatumDo': _datumDo
    });

    setState(() {
      result = data;
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
      } else {
        input.controller!.text = "";
      }
    }
    if (input is DropdownButton<int>) {
      setState(() {
        _dropdownValue = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: selected,
        child: Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      _buildSearch(),
                      /* Container(
                        height: 200,
                        color: Colors.yellow,
                      ),*/
                      _buildDataListView()
                    ],
                  )));
  }

  Widget _buildSearch() {
    return Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  InputField(
                      name: "Kategorija:",
                      field: DropdownButton<int>(
                          value: initial ? null : _dropdownValue,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 79, 79, 79)),
                          underline: Container(
                            height: 2,
                            color: Color.fromARGB(255, 178, 177, 177),
                          ),
                          isExpanded: true,
                          onChanged: (int? value) {
                            setState(() {
                              _dropdownValue = value!;
                              initial = false;
                            });
                          },
                          items: kategorijeResult?.result
                              .map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              alignment: AlignmentDirectional.center,
                              value: item.kategorijaId,
                              child: Text(item.naziv ?? ""),
                            );
                          }).toList()),
                      clearable: this),
                  InputField(
                    name: "Od:",
                    field: TextField(
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
                ],
              ),
              Row(
                children: [
                  InputField(
                    name: "Lokacija:",
                    field: TextField(
                      controller: _lokacijaController,
                    ),
                    clearable: this,
                  ),
                  InputField(
                    name: "Do:",
                    field: TextField(
                      controller:
                          // TextEditingController(text: _datumDo.toString()),
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
              ),
              Row(
                children: [
                  InputField(
                    name: "Naziv:",
                    field: TextField(
                      controller: _ftsController,
                    ),
                    clearable: this,
                  ),
                  InputField(
                    name: "",
                    field: ElevatedButton(
                        child: Text("Pretraga"),
                        onPressed: () async {
                          search();
                        }),
                  ),
                  /* _buildSearchField(
                    "",
                    ElevatedButton(
                        child: Text("New"),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DogadjajiDetailsScreen(),
                          ));
                        }),
                    false,
                  ),*/
                ],
              ),
            ],
          ),
        ));
  }

  Expanded _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
            /*child: Padding(
                    padding: const EdgeInsets.all(20),*/
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      DataTable(
          columns: [
            DataColumn(
              label: Expanded(
                child: Text(
                  'Naziv',
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
                  'Lokacija',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Organizator',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Uredi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Obriši',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            /* DataColumn(
              label: Expanded(
                child: Text(
                  'Slika',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),*/
          ],
          rows: result?.result
                  .map((Dogadjaj e) => DataRow(
                          /*  onSelectChanged: (selected) => {
                                    if (selected == true)
                                      {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DogadjajiDetailsScreen(
                                                    dogadjaj: e),
                                          ),
                                        )
                                      }
                                  },*/
                          cells: [
                            DataCell(Text(
                              e.naziv?.toString() ?? "",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataCell(Text(e.datumOd != null
                                ? "${e.datumOd?.day}.${e.datumOd?.month}.${e.datumOd?.year}."
                                : "")),
                            DataCell(Text(e.lokacija?.toString() ?? "")),
                            DataCell(Text(e.organizator?.toString() ?? "")),
                            DataCell(IconButton(
                                icon: const Icon(Icons.edit),
                                color: Color.fromRGBO(44, 152, 240, 1),
                                splashRadius: 20,
                                hoverColor: Color.fromRGBO(224, 224, 224, 1),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DogadjajiDetailsScreen(
                                              dogadjajId: e.dogadjajId),
                                    ),
                                  );
                                })),
                            DataCell(IconButton(
                              icon: const Icon(Icons.delete),
                              color: Color.fromRGBO(44, 152, 240, 1),
                              splashRadius: 20,
                              hoverColor: Color.fromRGBO(224, 224, 224, 1),
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Potvrdite akciju'),
                                    content: Text(
                                        'Da li stvarno želite obrisati događaj ${e.naziv}?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Odustani'),
                                        child: const Text('Odustani'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'Potvrdi');
                                          _dogadjajProvider
                                              .delete(e.dogadjajId!)
                                              .then((value) => search());
                                        },
                                        child: const Text('Potvrdi'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),

                            // DataCell(Text(formatNumber(e.cijena) ?? "")),
                            /* DataCell(e.naslovna!=""?Container(
                          width: 100,
                          height: 100,
                          child: imageFromBase64String(e.naslovna!):Text(""),
                        ))*/
                          ]))
                  .toList() ??
              []),
    ])));
  }
}
