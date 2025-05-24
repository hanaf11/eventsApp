import 'dart:convert';

import 'package:eventsappadmin/models/narudzba.dart';
import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/providers/narudzba_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/screens/narudzba_details_screen.dart';
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

  _buildNarudzbaDetails(int narudzbaId) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Detalji o narudžbi', style: h2),
        content: NarudzbaDetailsScreen(narudzbaId: narudzbaId),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Zatvori'),
            child: const Text('Zatvori'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              maxWidth: constraints.maxWidth,
            ),
            child: PaginatedDataTable(
              header: const Text('Narudžbe'),
              columns: [
                DataColumn(
                  label: Text(
                    'Broj narudžbe',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Datum',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Korisnik',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Cijena',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Detalji',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              source:
                  _MyDataSource(result?.result ?? [], _buildNarudzbaDetails),
              rowsPerPage: 5,
            ),
          ),
        );
      },
    );
  }
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

class _MyDataSource extends DataTableSource {
  final List<Narudzba> narudzbe;
  final void Function(int narudzbaId) buildNarudzbaDetails;

  _MyDataSource(this.narudzbe, this.buildNarudzbaDetails);

  @override
  DataRow? getRow(int index) {
    if (index >= narudzbe.length) return null;
    final e = narudzbe[index];
    return DataRow(cells: [
      DataCell(Text(e.brojNarudzbe.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("${e.datum?.day}.${e.datum?.month}.${e.datum?.year}.")),
      DataCell(Text(e.korisnickoIme ?? "")),
      DataCell(Text(formatCijena(e.cijena))),
      DataCell(IconButton(
        icon: const Icon(Icons.remove_red_eye),
        color: const Color.fromRGBO(44, 152, 240, 1),
        splashRadius: 20,
        hoverColor: const Color.fromRGBO(224, 224, 224, 1),
        onPressed: () {
          buildNarudzbaDetails(e.narudzbaId!);
        },
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => narudzbe.length;

  @override
  int get selectedRowCount => 0;
}
