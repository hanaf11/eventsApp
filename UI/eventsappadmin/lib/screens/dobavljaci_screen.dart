import 'dart:convert';
import 'dart:io';

import 'package:eventsappadmin/models/dobavljac.dart';
import 'package:eventsappadmin/models/kategorija.dart';
import 'package:eventsappadmin/models/podkategorija.dart';
import 'package:eventsappadmin/providers/dobavljac_provider.dart';
import 'package:eventsappadmin/providers/podkategorija_provider.dart';
import 'package:eventsappadmin/screens/dobavljac_details_screen.dart';
import 'package:eventsappadmin/utils/style_util.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:eventsappadmin/widgets/podkategorija_tile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../widgets/searchField.dart';

class DobavljaciScreen extends StatefulWidget {
  int? selected = 5;
  DobavljaciScreen({this.selected, super.key});

  @override
  State<DobavljaciScreen> createState() => _DobavljaciScreenState();
}

class _DobavljaciScreenState extends State<DobavljaciScreen>
    implements Clearable {
  int? selected;
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dogadjajSearchController =
      TextEditingController();
  final TextEditingController _adresaSearchController = TextEditingController();
  late DobavljacProvider _dobavljacProvider;
  late PodkategorijaProvider _podkategorijaProvider;
  SearchResult<Dobavljac>? result;
  SearchResult<Podkategorija>? podkategorijaResult;
  Kategorija? _selectedKategorija;
  Dobavljac? _selectedDobavljac;
  ImageObj? _kategorijaSlika = ImageObj(
      Image.asset(
        'assets/images/no_picture.jpg',
        fit: BoxFit.cover,
      ),
      null);

  _DobavljaciScreenState();

  @override
  void initState() {
    super.initState();
    _dobavljacProvider = context.read<DobavljacProvider>();
    getDobavljaci();
  }

  @override
  clear(dynamic input) {
    if (input is TextField) {
      input.controller!.text = "";
    }
  }

  void handleException(Exception e) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exception'),
        content: Text(e.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> getDobavljaci() async {
    var data = await _dobavljacProvider.get();
    setState(() {
      result = data;
      isLoading = false;
    });
  }

  void handleDobavljacSuccess(Dobavljac? value, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      refresh();
                    },
                    child: Text("OK"))
              ],
            ));
  }

  Future<void> deactivateDobavljac(Dobavljac d) async {
    if (d.status == false) {
      Exception e = Exception("Dobavljač je već deaktiviran");
      handleException(e);
      throw e;
    }
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Potvrdite akciju'),
              content: Text(
                  'Da li stvarno želite deaktivirati dobavljača ${d.naziv}?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Odustani'),
                  child: const Text('Odustani'),
                ),
                TextButton(
                  onPressed: () async {
                    await _dobavljacProvider
                        .changeStatus(d.dobavljacId!, false)
                        .then((value) {
                      Navigator.pop(context);
                      handleDobavljacSuccess(
                          null, "Uspješno ste deaktivirali dobavljača");
                    });
                  },
                  child: const Text('Potvrdi'),
                ),
              ],
            ));
  }

  Future<void> editDobavljac(int id) async {
    setState(() {
      isLoading = true;
    });
    _dobavljacProvider.getById(id).then((value) {
      setState(() {
        isLoading = false;
        _selectedDobavljac = value;
      });
      _buildDobavljacDetails(_selectedDobavljac);
    });
  }

  void addDobavljac() {
    setState(() {
      _selectedDobavljac = null;
    });
    _buildDobavljacDetails(_selectedDobavljac);
  }

  void refresh() {
    getDobavljaci();
  }

  Future<void> search() async {
    var data = await _dobavljacProvider.get(filter: {
      'Naziv': _searchController.text,
      'Adresa': _adresaSearchController.text,
      'Dogadjaj': _dogadjajSearchController.text
    });

    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: widget.selected,
        child: isLoading
            ? Expanded(
                child: Container(
                    child: Center(child: const CircularProgressIndicator())))
            : Expanded(
                child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        _buildSearch(),
                        _buildDataListViewDobavljaci(),
                      ],
                    )))));
  }

  Widget _buildSearch() {
    return Container(
      height: 170,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  InputField(
                    name: "Naziv:",
                    field: TextField(
                      controller: _searchController,
                    ),
                    clearable: this,
                  ),
                  InputField(
                    name: "Adresa:",
                    field: TextField(
                      controller: _adresaSearchController,
                    ),
                    clearable: this,
                  ),
                  InputField(
                    name: "Događaj:",
                    field: TextField(
                      controller: _dogadjajSearchController,
                    ),
                    clearable: this,
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text("Pretraga"),
                      style: buttonPrimary,
                      onPressed: () async {
                        search();
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text("Dodaj"),
                      style: buttonPrimary,
                      onPressed: () async {
                        addDobavljac();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDataListViewDobavljaci() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  maxWidth: constraints.maxWidth),
              child: PaginatedDataTable(
                header: Text("Dobavljači"),
                showCheckboxColumn: false,
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
                        'Telefon',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Aktivan',
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
                        'Deaktiviraj',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
                source: DobavljaciDataSource(
                    dobavljaci: result?.result ?? [],
                    onEdit: editDobavljac,
                    onDeactivate: deactivateDobavljac,
                    onSelect: (e) {
                      setState(() {
                        _selectedDobavljac = e;
                      });
                    }),
                rowsPerPage: 5,
              )));
    });
  }
 
  void _buildDobavljacDetails(Dobavljac? d) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => DobavljacDetailsScreen(
              selectedDobavljac: d,
              refresh: refresh,
            ));
  }
}

class DobavljaciDataSource extends DataTableSource {
  final List<Dobavljac> dobavljaci;
  final Function(int dobavljacId) onEdit;
  final Function(Dobavljac e) onDeactivate;
  final void Function(Dobavljac? e) onSelect;
  Dobavljac? selectedDobavljac;

  DobavljaciDataSource({
    required this.dobavljaci,
    required this.onEdit,
    required this.onDeactivate,
    required this.onSelect,
    this.selectedDobavljac,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= dobavljaci.length) return null;
    final e = dobavljaci[index];
    return DataRow.byIndex(
      index: index,
      selected: selectedDobavljac == e,
      onSelectChanged: (selected) {
        onSelect(selected == true ? e : null);
      },
      cells: [
        DataCell(
            Text(e.naziv ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(e.telefon ?? '',
            overflow: TextOverflow.ellipsis, maxLines: 1)),
        DataCell(
            Text(e.email ?? '', overflow: TextOverflow.ellipsis, maxLines: 1)),
        DataCell(Text(e.status.toString(),
            overflow: TextOverflow.ellipsis, maxLines: 1)),
        DataCell(IconButton(
          icon: const Icon(Icons.edit),
          color: Color.fromRGBO(44, 152, 240, 1),
          splashRadius: 20,
          hoverColor: Color.fromRGBO(224, 224, 224, 1),
          onPressed: () => onEdit(e.dobavljacId!),
        )),
        DataCell(IconButton(
          icon: const Icon(Icons.disabled_by_default_outlined),
          color: Color.fromRGBO(44, 152, 240, 1),
          splashRadius: 20,
          hoverColor: Color.fromRGBO(224, 224, 224, 1),
          onPressed: () async => await onDeactivate(e),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dobavljaci.length;

  @override
  int get selectedRowCount => selectedDobavljac == null ? 0 : 1;
}
