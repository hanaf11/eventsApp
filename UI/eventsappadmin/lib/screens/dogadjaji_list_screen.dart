import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/kategorija.dart';
import '../models/search_result.dart';
import '../providers/kategorija_provider.dart';

class DogadjajiListScreen extends StatefulWidget {
  DogadjajiListScreen({super.key});

  @override
  State<DogadjajiListScreen> createState() => _DogadjajiListScreenState();
}

class _DogadjajiListScreenState extends State<DogadjajiListScreen> {
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
    initForm();
    /*_datumOdController = TextEditingController(text: _datumOd.toString());
    _datumDoController = TextEditingController(text: _datumDo.toString());*/
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dogadjajProvider = context.read<DogadjajProvider>();
    //dropdownValue = kategorijeResult?.result[0].kategorijaId;
  }

  Future initForm() async {
    kategorijeResult = await _kategorijaProvider.get();

    setState(() {
      isLoading = false;
      //dropdownValue = kategorijeResult!.result[0].kategorijaId!;
    });
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

  search() async {
    var data = await _dogadjajProvider.get(filter: {
      'FTS': _ftsController.text,
      'Kategorija': _dropdownValue,
      'Lokacija': _lokacijaController.text,
      'DatumOd': _datumOdController.text,
      'DatumDo': _datumDoController.text
    });

    setState(() {
      result = data;
    });
  }

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
          child: Column(
        children: [
          isLoading ? Container() : _buildSearch(),
          _buildDataListView()
        ],
      )),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              /* _buildSearchField(
                  "Kategorija:",
                  TextField(
                    controller: _kategorijaController,
                  )),*/
              _buildSearchField(
                "Kategorija:",
                DropdownButton<int>(
                    value: initial ? null : _dropdownValue,
                    style:
                        const TextStyle(color: Color.fromARGB(255, 79, 79, 79)),
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
                true,
              ),
              _buildSearchField(
                "Od:",
                TextField(
                  controller:
                      // TextEditingController(text: _datumOd.toString()),
                      _datumOdController =
                          TextEditingController(text: _datumOd?.toString()),
                  readOnly: true,
                  key: const Key("_datumOd"),
                  onTap: () {
                    _showDatePicker("_datumOd");
                  },
                ),
                true,
              ),
            ],
          ),
          Row(
            children: [
              _buildSearchField(
                "Lokacija:",
                TextField(
                  controller: _lokacijaController,
                ),
                true,
              ),
              _buildSearchField(
                "Do:",
                TextField(
                  controller:
                      // TextEditingController(text: _datumDo.toString()),
                      _datumDoController = TextEditingController(
                          text: _datumDo != null ? _datumDo.toString() : null),
                  readOnly: true,
                  key: const Key("_datumDo"),
                  onTap: () {
                    _showDatePicker("_datumDo");
                  },
                ),
                true,
              ),
            ],
          ),
          Row(
            children: [
              _buildSearchField(
                "Naziv:",
                TextField(
                  controller: _ftsController,
                ),
                true,
              ),
              _buildSearchField(
                "",
                ElevatedButton(
                    child: Text("Pretraga"),
                    onPressed: () async {
                      search();
                    }),
                false,
              ),
            ],
          ),
        ],
      ),
    );
    /*ElevatedButton(
      child: Text("Get"),
      onPressed: () async {
        var data = await _dogadjajProvider.get();

        setState(() {
          result = data;
        });

        print("data ${data.result[0].naziv}");
      },
    );*/
  }

  Widget _buildSearchField(String name, Widget field, bool clearEnabled) {
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
        clearEnabled
            ? IconButton(
                onPressed: () {
                  clear(field);
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

  Padding _buildDataListView() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: DataTable(
              columns: [
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Naziv',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Datum',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Lokacija',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Organizator',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Uredi',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Obriši',
                      style: TextStyle(fontStyle: FontStyle.italic),
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
                                DataCell(Text(e.naziv?.toString() ?? "")),
                                DataCell(Text(e.datumOd != null
                                    ? "${e.datumOd?.day}.${e.datumOd?.month}.${e.datumOd?.year}."
                                    : "")),
                                DataCell(Text(e.lokacija?.toString() ?? "")),
                                DataCell(Text(e.dobavljacId?.toString() ?? "")),
                                DataCell(IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Color.fromRGBO(44, 152, 240, 1),
                                    splashRadius: 20,
                                    hoverColor:
                                        Color.fromRGBO(224, 224, 224, 1),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DogadjajiDetailsScreen(
                                                  dogadjaj: e),
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
                                            onPressed: () => Navigator.pop(
                                                context, 'Odustani'),
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
        ));
  }
}
