import 'dart:convert';

import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
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
        child: Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      _buildSearch(),
                      _buildDataListView(),
                    ],
                  )));
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
                  onPressed: () async {
                    search();
                  }),
            ),
          ],
        ),
      ),
    );
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
                  'Korisničko ime',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Član od',
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
            DataColumn(
              label: Expanded(
                child: Text(
                  'Obriši',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          rows: result?.result
                  .map((Korisnik e) => DataRow(cells: [
                        DataCell(Text(
                          e.korisnickoIme.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataCell(Text(
                            "${e.created.day}.${e.created.month}.${e.created.year}.")),
                        DataCell(ElevatedButton(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text("Detalji")),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ))),
                            onPressed: () {
                              setState(() {
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
                              });
                            })),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          color: Color.fromRGBO(44, 152, 240, 1),
                          splashRadius: 20,
                          hoverColor: Color.fromRGBO(224, 224, 224, 1),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Potvrdite akciju'),
                                content: Text(
                                    'Da li stvarno želite obrisati korisnika ${e.korisnickoIme}?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Odustani'),
                                    child: const Text('Odustani'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Potvrdi');
                                      _korisnikProvider
                                          .delete(e.korisnikId)
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

  _buildKorisnikDetails(Korisnik? k) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Detalji o korisniku'),
              content: isLoading
                  ? const CircularProgressIndicator()
                  : Column(
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
                                width: 200,
                                alignment: Alignment.topLeft,
                                //color: Colors.red,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          height: 20,
                        ),
                        Row(children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Narudžbe",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 71, 70, 70),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                ),
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
                    ),
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
