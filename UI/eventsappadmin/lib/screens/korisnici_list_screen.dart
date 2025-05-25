import 'dart:convert';

import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/screens/korisnik_details_screen.dart';
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

class KorisniciListScreen extends StatefulWidget {
  int? selected = 2;
  KorisniciListScreen({this.selected, super.key});

  @override
  State<KorisniciListScreen> createState() =>
      _KorisniciListScreenState(selected);
}

class _KorisniciListScreenState extends State<KorisniciListScreen>
    implements Clearable {
  int? selected;
  bool isLoading = true;
  final TextEditingController _usernameController = new TextEditingController();
  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? result;
  Korisnik? korisnik;

  _KorisniciListScreenState(this.selected);

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    getKorisnici();
  }

  @override
  clear(dynamic input) {
    if (input is TextField) {
      input.controller!.text = "";
    }
  }

  getKorisnici() async {
    var data = await _korisnikProvider.get();
    setState(() {
      result = data;
      isLoading = false;
    });
  }

  search() async {
    var data = await _korisnikProvider.get(filter: {
      'Username': _usernameController.text,
    });

    setState(() {
      result = data;
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
      height: 80,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            InputField(
              name: "Naziv:",
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
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataListView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SizedBox(
              width: constraints.maxWidth,
              child: PaginatedDataTable(
                header: Text("Korisnici"),
                columns: [
                  DataColumn(
                      label: Expanded(
                          child: Text('Korisničko ime',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  DataColumn(
                      label: Expanded(
                          child: Text('Član od',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  DataColumn(
                      label: Expanded(
                          child: Text('Detalji',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                  DataColumn(
                      label: Expanded(
                          child: Text('Obriši',
                              style: TextStyle(fontWeight: FontWeight.bold)))),
                ],
                source: KorisnikDataSource(
                  korisnici: result?.result ?? [],
                  onDetailsPressed: (int korisnikId) {
                    _buildKorisnikDetails(korisnikId);
                  },
                  onDeletePressed: (int korisnikId, String korisnickoIme) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Potvrdite akciju'),
                        content: Text(
                            'Da li stvarno želite obrisati korisnika $korisnickoIme?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Odustani'),
                            child: const Text('Odustani'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Potvrdi');
                              _korisnikProvider
                                  .delete(korisnikId)
                                  .then((value) => search());
                            },
                            child: const Text('Potvrdi'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                rowsPerPage: 5,
              ),
            ),
          ),
        );
      },
    );
  }

  _buildKorisnikDetails(int korisnikId) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Detalji o korisniku', style: h2),
        content: KorisnikDetailsScreen(korisnikId: korisnikId),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Zatvori'),
            child: const Text('Zatvori'),
          ),
        ],
      ),
    );

    /* showDialog<String>(
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
            ));*/
  }
}

class KorisnikDataSource extends DataTableSource {
  final List<Korisnik> korisnici;
  final void Function(int korisnikId) onDetailsPressed;
  final void Function(int korisnikId, String korisnickoIme) onDeletePressed;

  KorisnikDataSource({
    required this.korisnici,
    required this.onDetailsPressed,
    required this.onDeletePressed,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= korisnici.length) return null;
    final e = korisnici[index];

    return DataRow(cells: [
      DataCell(Text(e.korisnickoIme.toString(),
          style: TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("${e.created.day}.${e.created.month}.${e.created.year}.")),
      DataCell(IconButton(
        icon: const Icon(Icons.remove_red_eye),
        color: Color.fromRGBO(44, 152, 240, 1),
        splashRadius: 20,
        hoverColor: Color.fromRGBO(224, 224, 224, 1),
        onPressed: () => onDetailsPressed(e.korisnikId),
      )),
      DataCell(IconButton(
        icon: const Icon(Icons.delete),
        color: Color.fromRGBO(44, 152, 240, 1),
        splashRadius: 20,
        hoverColor: Color.fromRGBO(224, 224, 224, 1),
        onPressed: () => onDeletePressed(e.korisnikId, e.korisnickoIme),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => korisnici.length;

  @override
  int get selectedRowCount => 0;
}
