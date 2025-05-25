import 'dart:convert';
import 'dart:io';

import 'package:eventsappadmin/models/kategorija.dart';
import 'package:eventsappadmin/models/podkategorija.dart';
import 'package:eventsappadmin/providers/kategorija_provider.dart';
import 'package:eventsappadmin/providers/podkategorija_provider.dart';
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

class KategorijeScreen extends StatefulWidget {
  int? selected = 4;
  KategorijeScreen({this.selected, super.key});

  @override
  State<KategorijeScreen> createState() => _KategorijeScreenState();
}

class _KategorijeScreenState extends State<KategorijeScreen>
    implements Clearable {
  int? selected;
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  late KategorijaProvider _kategorijaProvider;
  late PodkategorijaProvider _podkategorijaProvider;
  SearchResult<Kategorija>? result;
  SearchResult<Podkategorija>? podkategorijaResult;
  Kategorija? _selectedKategorija;
  ImageObj? _kategorijaSlika = ImageObj(
      Image.asset(
        'assets/images/no_picture.jpg',
        fit: BoxFit.cover,
      ),
      null);

  _KategorijeScreenState();

  @override
  void initState() {
    super.initState();
    _kategorijaProvider = context.read<KategorijaProvider>();
    _podkategorijaProvider = context.read<PodkategorijaProvider>();
    getKategorije();
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

  getKategorije() async {
    var data = await _kategorijaProvider.get();
    setState(() {
      result = data;
      isLoading = false;
    });
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

  editKategorija(int id) async {
    setState(() {
      isLoading = true;
    });
    await getPodkategorije(id);
    _kategorijaProvider.getById(id).then((value) {
      setState(() {
        isLoading = false;
        _selectedKategorija = value;
        _kategorijaSlika = ImageObj(
            imageFromBase64String(_selectedKategorija?.slika),
            _selectedKategorija?.slika);
      });
      _buildKategorijaDetails(_selectedKategorija);
    });
  }

  deleteKategorija(Kategorija e) async {
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
  }

  void addKategorija() {
    setState(() {
      _selectedKategorija = null;
      podkategorijaResult = null;
      _kategorijaSlika = null;
    });

    _buildKategorijaDetails(_selectedKategorija);
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

  refresh(int? id) {
    search();
    if (_selectedKategorija == null && id != null) {
      getPodkategorije(id);
    } else {
      getPodkategorije(_selectedKategorija!.kategorijaId!);
    }
  }

  search() async {
    var data = await _kategorijaProvider.get(filter: {
      'fts': _searchController.text,
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
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        _buildSearch(),
                        _buildDataListViewKategorije(),
                        SizedBox(
                          height: 20,
                        ),
                        _selectedKategorija != null
                            ? Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("Podkategorije",
                                            style: h2,
                                            textAlign: TextAlign.left)),
                                  ),
                                  _buildPodkategorije(_selectedKategorija!)
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    )))));
  }

  Widget _buildSearch() {
    return Container(
      height: 80,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            InputField(
              name: "Naziv:",
              field: TextField(
                controller: _searchController,
              ),
              clearable: this,
            ),
            Expanded(
                child: InkWell(
              child: ElevatedButton(
                  child: Text("Pretraga"),
                  style: buttonPrimary,
                  onPressed: () async {
                    search();
                  }),
            )),
            SizedBox(
              width: 15,
            ),
            Expanded(
                child: InkWell(
              child: ElevatedButton(
                  child: Text("Dodaj"),
                  style: buttonPrimary,
                  onPressed: () async {
                    addKategorija();
                  }),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDataListViewKategorije() {
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
              header: const Text('Kategorije'),
              showCheckboxColumn: false,
              columns: [
                DataColumn(
                  label: Text(
                    'Naziv',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Opis',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Slika',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Uredi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Obriši',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              source: _KategorijeDataSource(
                result?.result ?? [],
                editKategorija,
                deleteKategorija,
                buildSlika,
                (kategorijaId) {
                  setState(() {
                    _selectedKategorija = result!.result!
                        .firstWhere((k) => k.kategorijaId == kategorijaId);
                  });
                  getPodkategorije(kategorijaId);
                },
              ),
              rowsPerPage: 5,
            ),
          ),
        );
      },
    );
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

  _buildKategorijaDetails(Kategorija? k) {
    List<Podkategorija>? podkategorijeList = podkategorijaResult?.result;
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => KategorijeDetailsScreen(
              selectedKategorija: k,
              kategorijaSlika: _kategorijaSlika,
              imageChanged: imageChanged,
              refresh: refresh,
              podkategorijeList: podkategorijeList,
            ));
  }

  Image buildSlika(String? img) {
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

class _KategorijeDataSource extends DataTableSource {
  final List<Kategorija> kategorije;
  final Function(int kategorijaId) onEdit;
  final Function(Kategorija kategorija) onDelete;
  final Function(int kategorijaId) onSelect;
  final Function(String img) buildSlika;

  _KategorijeDataSource(this.kategorije, this.onEdit, this.onDelete,
      this.buildSlika, this.onSelect);

  @override
  DataRow? getRow(int index) {
    if (index >= kategorije.length) return null;
    final e = kategorije[index];
    return DataRow(
      onSelectChanged: (selected) {
        if (selected == true) {
          onSelect(e.kategorijaId!);
        }
      },
      cells: [
        DataCell(Text(
          e.naziv ?? "",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          e.opis ?? "",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )),
        DataCell(buildSlika(e.slika ?? "")),
        DataCell(IconButton(
          icon: Icon(Icons.edit),
          color: Color.fromRGBO(44, 152, 240, 1),
          splashRadius: 20,
          hoverColor: Color.fromRGBO(224, 224, 224, 1),
          onPressed: () => onEdit(e.kategorijaId!),
        )),
        DataCell(IconButton(
          icon: Icon(Icons.delete),
          color: Color.fromRGBO(44, 152, 240, 1),
          splashRadius: 20,
          hoverColor: Color.fromRGBO(224, 224, 224, 1),
          onPressed: () => onDelete(e),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => kategorije.length;

  @override
  int get selectedRowCount => 0;
}
