import 'dart:convert';
import 'dart:io';

import 'package:eventsappadmin/models/dobavljac.dart';
import 'package:eventsappadmin/models/kategorija.dart';
import 'package:eventsappadmin/models/podkategorija.dart';
import 'package:eventsappadmin/providers/dobavljac_provider.dart';
import 'package:eventsappadmin/providers/kategorija_provider.dart';
import 'package:eventsappadmin/providers/podkategorija_provider.dart';
import 'package:eventsappadmin/screens/dobavljac_details_screen.dart';
import 'package:eventsappadmin/screens/kategorije_details_screen.dart';
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

  handleException(Exception e) {
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

  getDobavljaci() async {
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

  deactivateDobavljac(Dobavljac d) async {
    if (d.status == false) {
      Exception e = Exception("Dobavljač je već deaktiviran");
      handleException(e);
      throw e;
    }
    await _dobavljacProvider.changeStatus(d.dobavljacId!, false).then((value) =>
        handleDobavljacSuccess(null, "Uspješno ste deaktivirali dobavljača"));
  }

  getPodkategorije(int kategorijaId) async {
    var data = await _podkategorijaProvider.get(filter: {
      'KategorijaId': kategorijaId,
    });
    setState(() {
      podkategorijaResult = data;
    });
  }

  imageChanged(ImageObj imageObj) {
    setState(() {
      _kategorijaSlika = imageObj;
    });
  }

  editDobavljac(int id) async {
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

  /* deleteKategorija(Kategorija e) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Potvrdite akciju'),
        content: Text('Da li stvarno želite obrisati kategoriju ${e.naziv}?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Odustani'),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'Potvrdi');
              if (podkategorijaResult != null &&
                  podkategorijaResult?.result != null &&
                  podkategorijaResult!.result.isNotEmpty) {
                podkategorijaResult?.result.forEach((p) async =>
                    await _podkategorijaProvider.delete(p.podkategorijaId));
              }

              try {
                await _kategorijaProvider.delete(e.kategorijaId!).then((value) {
                  search();
                  setState(() {
                    podkategorijaResult = null;
                    _selectedKategorija = null;
                  });
                });
              } on Exception catch (ex) {
                handleException(ex);
              }
            },
            child: const Text('Potvrdi'),
          ),
        ],
      ),
    );
  }*/

  void addDobavljac() {
    setState(() {
      _selectedDobavljac = null;
    });

    _buildDobavljacDetails(_selectedDobavljac);
  }

  Future<ImageObj> getImage() async {
    File? file;
    String? base64Image;
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!);
      base64Image = base64Encode(file!.readAsBytesSync());
      final image = ImageObj(
          Image.file(
            file,
            fit: BoxFit.cover,
          ),
          base64Image);
      return image;
    }
    return _kategorijaSlika ??
        ImageObj(
            Image.asset(
              'assets/images/no_picture.jpg',
              fit: BoxFit.cover,
            ),
            null);
  }

  refresh() {
    // search();
    getDobavljaci();
  }

  search() async {
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
            ),
            child: DataTable(
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
                rows: result?.result
                        .map((Dobavljac e) => DataRow(
                                onSelectChanged: (selected) {
                                  if (selected == true) {
                                    setState(() {
                                      _selectedDobavljac = e;
                                    });
                                  }
                                },
                                cells: [
                                  DataCell(Text(
                                    e.naziv ?? '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(Text(
                                    e.telefon ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  )),
                                  DataCell(Text(
                                    e.email ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  )),
                                  DataCell(Text(
                                    e.status.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  )),
                                  DataCell(IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: Color.fromRGBO(44, 152, 240, 1),
                                      splashRadius: 20,
                                      hoverColor:
                                          Color.fromRGBO(224, 224, 224, 1),
                                      onPressed: () {
                                        editDobavljac(e.dobavljacId!);
                                      })),
                                  DataCell(IconButton(
                                      icon: const Icon(
                                          Icons.disabled_by_default_outlined),
                                      color: Color.fromRGBO(44, 152, 240, 1),
                                      splashRadius: 20,
                                      hoverColor:
                                          Color.fromRGBO(224, 224, 224, 1),
                                      onPressed: () async {
                                        await deactivateDobavljac(e);
                                      })),
                                ]))
                        .toList() ??
                    []),
          ));
    });
  }

  Widget _buildPodkategorije(Kategorija? kategorija) {
    return kategorija != null
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Podkategorije za odabranu kategoriju: ${kategorija?.naziv}",
                      textAlign: TextAlign.left,
                    )),
                podkategorijaResult == null ||
                        podkategorijaResult?.result == null ||
                        podkategorijaResult?.count == 0
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Nisu dodane podkategorije",
                          textAlign: TextAlign.left,
                        ))
                    : Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                              itemCount: podkategorijaResult?.count,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return PodkategorijaTile(
                                    text: podkategorijaResult!
                                        .result[index].naziv);
                              },
                            )))
              ],
            ))
        : Container();
  }

  _buildDobavljacDetails(Dobavljac? d) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => DobavljacDetailsScreen(
              selectedDobavljac: d,
              refresh: refresh,
            ));
  }

  Image _buildSlika(String? img) {
    Image emptyImage = Image.asset(
      'assets/images/no_picture.jpg',
      fit: BoxFit.cover,
      height: 40,
      width: 40,
    );
    if (img == null || img == "") {
      return emptyImage;
    } else {
      try {
        Image slika = Image.memory(
          base64Decode(img),
          fit: BoxFit.cover,
          height: 50,
          width: 50,
        );
        return slika;
      } on Exception catch (e) {
        return emptyImage;
      }
    }
  }
}
