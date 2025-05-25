import 'dart:convert';

import 'package:eventsappadmin/models/korisnik.dart';
import 'package:eventsappadmin/models/narudzba.dart';
import 'package:eventsappadmin/models/search_result.dart';
import 'package:eventsappadmin/models/stavke_narudzbe.dart';
import 'package:eventsappadmin/providers/korisnik_provider.dart';
import 'package:eventsappadmin/providers/narudzba_provider.dart';
import 'package:eventsappadmin/providers/stavke_narudzbe_provider.dart';
import 'package:eventsappadmin/utils/style_util.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KorisnikDetailsScreen extends StatefulWidget {
  int korisnikId;

  KorisnikDetailsScreen({required this.korisnikId, super.key});

  @override
  State<KorisnikDetailsScreen> createState() => _KorisnikDetailsScreenState();
}

class _KorisnikDetailsScreenState extends State<KorisnikDetailsScreen> {
  late NarudzbaProvider _narudzbaProvider;
  late KorisnikProvider _korisnikProvider;
  Korisnik? korisnik;
  bool isKorisnikLoading = true;
  bool isNarudzbaLoading = true;
  bool isLoading = true;
  late SearchResult<Narudzba> narudzbe;

  @override
  void initState() {
    super.initState();
    _narudzbaProvider = context.read<NarudzbaProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();
    getData();
  }

  getData() async {
    var data = await _korisnikProvider.getById(widget.korisnikId);
    setState(() {
      korisnik = data;
      isKorisnikLoading = false;
      handleLoading();
    });

    var narudzbeData = await _narudzbaProvider
        .get(filter: {'Username': korisnik?.korisnickoIme});
    setState(() {
      narudzbe = narudzbeData;
      isNarudzbaLoading = false;
      handleLoading();
    });
  }

  handleLoading() {
    if (isNarudzbaLoading == false && isKorisnikLoading == false) {
      setState(() {
        isLoading = false;
      });
    }
  }

  /*@override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: isLoading
          ? Container(child: Center(child: const CircularProgressIndicator()))
          : korisnik != null
              ? Container(
                  width: 600,
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 80,
                                    width: 80,
                                    margin: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: korisnik != null
                                            ? _buildProfilna(korisnik?.slika)
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
                                          "${korisnik?.ime} ${korisnik?.prezime}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 71, 70, 70),
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text("@${korisnik?.korisnickoIme}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 90, 89, 89),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300)),
                                        Text("${korisnik?.email}",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          Text(
                                              "${korisnik?.adresa}, ${korisnik?.drzava}",
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
                                          Text("${korisnik?.telefon}",
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
                                              korisnik?.status == true
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
                                              "${korisnik?.created.day}.${korisnik?.created.month}.${korisnik?.created.year}.",
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
                                    narudzbe.result == null ||
                                            narudzbe.result.isEmpty
                                        ? const Text(
                                            "Korisnik nije izvršio nijednu narudžbu.",
                                            textAlign: TextAlign.left,
                                          )
                                        : _buildNarudzbeListView()
                                  ])
                            ]),
                          ]))))
              : Container(),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        height: 400,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: isLoading
              ? Container(
                  child: Center(child: const CircularProgressIndicator()))
              : korisnik != null
                  ? SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(children: [
                            SizedBox(
                                height: 200,
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 80,
                                          width: 80,
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: korisnik != null
                                                  ? _buildProfilna(
                                                      korisnik?.slika)
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
                                                "${korisnik?.ime} ${korisnik?.prezime}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 71, 70, 70),
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                  "@${korisnik?.korisnickoIme}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 90, 89, 89),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              Text("${korisnik?.email}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300))
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Adresa:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 71, 70, 70),
                                                        fontSize: 16)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    "${korisnik?.adresa}, ${korisnik?.drzava}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.grey,
                                                        fontSize: 16))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Telefon:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 71, 70, 70),
                                                        fontSize: 16)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text("${korisnik?.telefon}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.grey,
                                                        fontSize: 16))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Status:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 71, 70, 70),
                                                        fontSize: 16)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    korisnik?.status == true
                                                        ? "Aktivan"
                                                        : "Deaktiviran",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.grey,
                                                        fontSize: 16))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Račun kreiran:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 71, 70, 70),
                                                        fontSize: 16)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    "${korisnik?.created.day}.${korisnik?.created.month}.${korisnik?.created.year}.",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.grey,
                                                        fontSize: 16))
                                              ],
                                            )
                                          ])
                                    ],
                                  ),
                                ])),
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
                                    narudzbe.result == null ||
                                            narudzbe.result.isEmpty
                                        ? const Text(
                                            "Korisnik nije izvršio nijednu narudžbu.",
                                            textAlign: TextAlign.left,
                                          )
                                        : _buildNarudzbeListView()
                                  ])
                            ]),
                          ])))
                  : Container(),
        ));
  }

  /* Widget _buildNarudzbeListView() {
    return DataTable(
        showCheckboxColumn: false,
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
                'Cijena',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
        rows: narudzbe.result
                .map((Narudzba e) => DataRow(cells: [
                      DataCell(Text(
                        e.brojNarudzbe ?? '',
                      )),
                      DataCell(Text(
                        "${e!.datum?.day}.${e!.datum?.month}.${e!.datum?.year}.",
                      )),
                      DataCell(Text(
                        formatCijena(e.cijena),
                      )),
                    ]))
                .toList() ??
            []);
  }*/

  Widget _buildNarudzbeListView() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.57,
            child: PaginatedDataTable(
              showCheckboxColumn: false,
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
                      'Cijena',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              source: NarudzbeDataSource(narudzbe.result ?? []),
              rowsPerPage: 5,
            )));
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

class NarudzbeDataSource extends DataTableSource {
  final List<Narudzba> narudzbe;

  NarudzbeDataSource(this.narudzbe);

  @override
  DataRow? getRow(int index) {
    if (index >= narudzbe.length) return null;
    final e = narudzbe[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(e.brojNarudzbe ?? '')),
        DataCell(Text("${e.datum?.day}.${e.datum?.month}.${e.datum?.year}.")),
        DataCell(Text(formatCijena(e.cijena))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => narudzbe.length;

  @override
  int get selectedRowCount => 0;
}
