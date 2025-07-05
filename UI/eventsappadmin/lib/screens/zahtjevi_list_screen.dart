import 'package:eventsappadmin/models/tipkarte.dart';
import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/providers/tipkarte_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/input_widget.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dogadjaj.dart';

class ZahtjeviListScreen extends StatefulWidget {
  int? selected = 1;
  ZahtjeviListScreen({this.selected, super.key});

  @override
  State<ZahtjeviListScreen> createState() =>
      _ZahtjeviListScreenState(selected: selected);
}

class _ZahtjeviListScreenState extends State<ZahtjeviListScreen> {
  int? selected = 1;
  bool _isLoading = true;
  late DogadjajProvider _dogadjajProvider;
  late TipkarteProvider _tipkarteProvider;
  List<Dogadjaj>? _zahtjeviList = [];
  List<Dogadjaj>? _verifiedList = [];
  Dogadjaj? _selectedZahtjev;
  Dogadjaj? _selectedVerified;
  bool zahtjeviLoaded = false;
  bool verifiedLoaded = false;
  List<TipKarte>? tipovi;
  List<RowData>? rows = [];
  bool tipKarteLoaded = false;
  _ZahtjeviListScreenState({this.selected});

  @override
  void initState() {
    super.initState();
    _dogadjajProvider = context.read<DogadjajProvider>();
    _tipkarteProvider = context.read<TipkarteProvider>();
    getZahtjevi();
  }

  void handleLoading() {
    if (zahtjeviLoaded && verifiedLoaded) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getZahtjevi() async {
    var zahtjeviResult = await _dogadjajProvider
        .get(filter: {'Status': 'DRAFT', 'DatumOd': DateTime.now()});
    setState(() {
      _zahtjeviList = zahtjeviResult.result;
      zahtjeviLoaded = true;
      handleLoading();
    });

    loadVerifiedEvents();
  }

  Future<void> loadVerifiedEvents() async {
    setState(() {
      verifiedLoaded = false;
    });
    var verifiedResult = await _dogadjajProvider.findVerified();
    setState(() {
      _verifiedList = verifiedResult.result;
      verifiedLoaded = true;
      handleLoading();
    });
  }

  void openZahtjev(int dogadjajId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DogadjajiDetailsScreen(
          dogadjajId: dogadjajId, zahtjev: true, refresh: getZahtjevi),
    ));
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

  void sendRequestForTickets() {
    List<KarteRequest> karteList = rows?.map((tip) {
          return KarteRequest(
              Naziv: tip.tipKarteController.text,
              Cijena: double.parse(tip.cijenaController.text),
              Kolicina: int.parse(tip.kolicinaController.text),
              NumerisanjeSjedista: tip.numerisanjeSjedista);
        }).toList() ??
        [];

    _dogadjajProvider
        .sendRequestForTickets(_selectedVerified!.dogadjajId!, karteList)
        .then((val) => {handleKarteZahtjevSuccess()})
        .catchError((e) => handleException(e));
  }

  void handleKarteZahtjevSuccess() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content:
                  Text("Uspješno ste dobavljaču poslali zahtjev za ulaznice"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      loadVerifiedEvents();
                    },
                    child: Text("OK"))
              ],
            ));
  }


  Future<void> onSendPressed(Dogadjaj e) async {
    if (calculateWhetherEnabled(e.status)) {
      setState(() {
        _selectedVerified = e;
      });

      await _tipkarteProvider.get(
          filter: {'DogadjajId': _selectedVerified?.dogadjajId}).then((val) {
        setState(() {
          tipovi = val.result;
          tipKarteLoaded = true;
          rows = tipovi?.map((tip) {
            return RowData(
                tipKarteController: TextEditingController(text: tip.naziv),
                cijenaController:
                    TextEditingController(text: tip.cijena.toString()),
                kolicinaController: TextEditingController(),
                numerisanjeSjedista: tip.numerisanjeSjedista ?? false);
          }).toList();
        });
      });
      _openPopup(e);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Exception"),
            content: Text("Događaj nije u odgovarajućem statusu"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: selected,
        child: _isLoading
            ? Expanded(
                child: Container(
                    child: Center(child: const CircularProgressIndicator())))
            : Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDataListViewZahtjevi(),
                          SizedBox(
                            height: 40,
                          ),
                          _buildDataListViewKarte()
                        ],
                      ),
                    )))));
  }

  Widget _buildDataListViewZahtjevi() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                maxWidth: constraints.maxWidth,
              ),
              child: PaginatedDataTable(
                header: const Text('Zahtjevi za kreiranje događaja'),
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
                        'Datum od',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Datum do',
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
                        'Pregledaj',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
                source: _ZahtjeviDataSource(_zahtjeviList ?? [], openZahtjev),
                rowsPerPage: 5,
              )));
    });
  }

  Widget _buildDataListViewKarte() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  maxWidth: constraints.maxWidth),
              child: PaginatedDataTable(
                header: Text("Pošalji zahtjev za karte dobavljaču"),
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
                        'Dobavljač',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Pošalji',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
                source: DogadjajDataSource(
                  dogadjaji: _verifiedList ?? [],
                  onSendPressed: onSendPressed,
                  selectedDogadjaj: _selectedVerified,
                  onSelectedChanged: (Dogadjaj? selected) {
                    setState(() {
                      _selectedVerified = selected;
                    });
                  },
                ),
                rowsPerPage: 5,
              )));
    });
  }

  bool calculateWhetherEnabled(status) {
    return status != null && status == 'VERIFIED';
  }

  Future<void> _openPopup(Dogadjaj dog) async {
    setState(() {
      _selectedVerified = dog;
    });
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Zahtjev za karte'),
          content: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tipKarteLoaded == false
                  ? Expanded(child: Center(child: CircularProgressIndicator()))
                  : const Text("Dobavljač",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 91, 91, 91),
                      )),
              Text("Dobavljač: ${dog.dobavljac?.naziv}"),
              Text("Adresa: ${dog.dobavljac?.adresa}"),
              Text("Telefon: ${dog.dobavljac?.telefon}"),
              Text("Email: ${dog.dobavljac?.email}"),
              SizedBox(
                height: 30,
              ),
              Text("Unesite željenu količinu karata:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 91, 91, 91),
                  )),
              _buildRows()
            ],
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Odustani'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Pošalji'),
              onPressed: () {
                sendRequestForTickets();
              },
            ),
          ],
        );
      },
    );
  }

  Column _buildRows() {
    return Column(
      children: rows?.map((rowData) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: InputWidget(
                      readOnly: true,
                      label: 'Tip karte',
                      controller: rowData.tipKarteController,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: InputWidget(
                      readOnly: true,
                      label: 'Cijena',
                      controller: rowData.cijenaController,
                      type: 'number',
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: InputWidget(
                      label: 'Količina',
                      controller: rowData.kolicinaController,
                      type: 'number',
                    ),
                  ),
                ],
              ),
            );
          }).toList() ??
          [],
    );
  }
}

class RowData {
  TextEditingController tipKarteController;
  TextEditingController cijenaController;
  TextEditingController kolicinaController;
  bool numerisanjeSjedista;

  RowData(
      {required this.tipKarteController,
      required this.cijenaController,
      required this.kolicinaController,
      required this.numerisanjeSjedista});
}

class KarteRequest {
  String Naziv;
  double Cijena;
  int Kolicina;
  bool NumerisanjeSjedista;

  KarteRequest(
      {required this.Naziv,
      required this.Cijena,
      required this.Kolicina,
      required this.NumerisanjeSjedista});

  Map<String, dynamic> toJson() {
    return {
      'Naziv': Naziv,
      'Cijena': Cijena,
      'Kolicina': Kolicina,
      'NumerisanjeSjedista': NumerisanjeSjedista
    };
  }
}

class _ZahtjeviDataSource extends DataTableSource {
  final List<Dogadjaj> zahtjevi;
  final Function(int dogadjajId) onOpen;
  int? _selectedIndex;

  _ZahtjeviDataSource(this.zahtjevi, this.onOpen);

  @override
  DataRow? getRow(int index) {
    if (index >= zahtjevi.length) return null;
    final e = zahtjevi[index];
    return DataRow.byIndex(
      index: index,
      selected: _selectedIndex == index,
      onSelectChanged: (selected) {
        if (selected == true) {
          _selectedIndex = index;
          notifyListeners();
        } else {
          _selectedIndex = null;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(
          e.naziv ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(printDate(e.datumOd))),
        DataCell(Text(printDate(e.datumDo))),
        DataCell(Text(
          e.lokacija ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )),
        DataCell(Text(
          e.organizator ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )),
        DataCell(
          IconButton(
            icon: const Icon(Icons.open_in_full),
            color: Color.fromRGBO(44, 152, 240, 1),
            splashRadius: 20,
            hoverColor: Color.fromRGBO(224, 224, 224, 1),
            onPressed: () => onOpen(e.dogadjajId!),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => zahtjevi.length;

  @override
  int get selectedRowCount => _selectedIndex == null ? 0 : 1;
}

class DogadjajDataSource extends DataTableSource {
  final List<Dogadjaj> dogadjaji;
  final void Function(Dogadjaj) onSendPressed;
  final Function(Dogadjaj?) onSelectedChanged;
  final Dogadjaj? selectedDogadjaj;

  DogadjajDataSource({
    required this.dogadjaji,
    required this.onSendPressed,
    required this.onSelectedChanged,
    required this.selectedDogadjaj,
  });

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= dogadjaji.length) return null;
    final e = dogadjaji[index];

    return DataRow(
      selected: e == selectedDogadjaj,
      onSelectChanged: (selected) {
        onSelectedChanged(selected == true ? e : null);
      },
      cells: [
        DataCell(Text(e.naziv ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(printDate(e.datumOd))),
        DataCell(Text(e.lokacija ?? '',
            overflow: TextOverflow.ellipsis, maxLines: 1)),
        DataCell(Text(e.organizator ?? '',
            overflow: TextOverflow.ellipsis, maxLines: 1)),
        DataCell(Text(e.dobavljac?.naziv ?? '',
            overflow: TextOverflow.ellipsis, maxLines: 1)),
        DataCell(
            Text(e.status ?? '', overflow: TextOverflow.ellipsis, maxLines: 1)),
        DataCell(
          IconButton(
            icon: Icon(Icons.send),
            color: Color.fromRGBO(44, 152, 240, 1),
            disabledColor: Colors.grey,
            splashRadius: 20,
            hoverColor: Color.fromRGBO(224, 224, 224, 1),
            onPressed: () => onSendPressed(e),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dogadjaji.length;

  @override
  int get selectedRowCount => selectedDogadjaj == null ? 0 : 1;
}
