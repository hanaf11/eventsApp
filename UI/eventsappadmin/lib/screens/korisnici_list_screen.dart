import 'dart:convert';

import 'package:eventsappadmin/models/korisnik_global.dart';
import 'package:eventsappadmin/models/uloga.dart';
import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/providers/uloga_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/screens/korisnik_details_screen.dart';
import 'package:eventsappadmin/utils/style_util.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
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
  late UlogaProvider _ulogaProvider;
  SearchResult<Korisnik>? result;
  List<Uloga>? _ulogeList;
  Korisnik? korisnik;
  final _userFormKey = GlobalKey<FormBuilderState>();
  bool isKorisniciLoading = true;
  bool isUlogeLoading = true;

  _KorisniciListScreenState(this.selected);

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    _ulogaProvider = context.read<UlogaProvider>();
    getKorisnici();
    getUloge();
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
      isKorisniciLoading = false;
    });
    handleLoading();
  }

  getUloge() async {
    var data = await _ulogaProvider.get();
    setState(() {
      _ulogeList = data.result;
      isUlogeLoading = false;
    });
    handleLoading();
  }

  handleLoading() {
    if (isKorisniciLoading == false && isUlogeLoading == false) {
      setState(() {
        isLoading = false;
      });
    }
  }

  search() async {
    var data = await _korisnikProvider.get(filter: {
      'Username': _usernameController.text,
    });

    setState(() {
      result = data;
    });
  }

  void _handleDeleteSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Successful"),
          content: Text("Korisnik je uspješno obrisan"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                search();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  handleSuccess(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      search();
                    },
                    child: Text("OK"))
              ],
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

  addUser() {
    bool canAccess = KorisnikGlobal.uloge?.contains("Admin") ?? false;
    if (canAccess) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Dodaj korisnika'),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 800,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: SingleChildScrollView(
                      child: FormBuilder(
                          key: _userFormKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 800,
                                    child: Column(children: [
                                      InputField(
                                        name: "Ime:",
                                        field: FormBuilderTextField(
                                          name: 'ime',
                                          style: TextStyle(fontSize: 14),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText: 'Polje je obavezno'),
                                          ]),
                                        ),
                                      ),
                                      InputField(
                                        name: "Prezime:",
                                        field: FormBuilderTextField(
                                          name: 'prezime',
                                          style: TextStyle(fontSize: 14),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText: 'Polje je obavezno'),
                                          ]),
                                        ),
                                      ),
                                      InputField(
                                        name: "Email:",
                                        field: FormBuilderTextField(
                                          name: 'email',
                                          style: TextStyle(fontSize: 14),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText: 'Polje je obavezno'),
                                            FormBuilderValidators.email(
                                                errorText: "Email nije validan")
                                          ]),
                                        ),
                                      ),
                                      InputField(
                                        name: "Korisničko ime:",
                                        field: FormBuilderTextField(
                                          name: 'korisnickoIme',
                                          style: TextStyle(fontSize: 14),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText: 'Polje je obavezno'),
                                            FormBuilderValidators.match(
                                              RegExp(r'^[a-zA-Z0-9]{3,32}$'),
                                              errorText:
                                                  "Korisničko ime treba sadržavati između 3-32 karaktera\nSamo slova i brojevi",
                                            )
                                          ]),
                                        ),
                                      ),
                                      InputField(
                                        name: "Lozinka:",
                                        field: FormBuilderTextField(
                                          name: 'password',
                                          style: TextStyle(fontSize: 14),
                                          obscureText: true,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText: 'Polje je obavezno'),
                                            FormBuilderValidators.password(
                                              errorText:
                                                  "Lozinka treba sadržavati između 8-32 karaktera, Minimalno jedno malo slovo \nMinimalno jedno veliko slovo, Minimalno jedan broj \nMinimalno jedan specijalni karakter",
                                            )
                                          ]),
                                        ),
                                      ),
                                      InputField(
                                        name: "Potvrda lozinke:",
                                        field: FormBuilderTextField(
                                          name: 'passwordPotvrda',
                                          style: TextStyle(fontSize: 14),
                                          obscureText: true,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText: 'Polje je obavezno'),
                                            FormBuilderValidators.password(
                                              errorText:
                                                  "Lozinka treba sadržavati između 8-32 karaktera, minimalno jedno malo slovo \nMinimalno jedno veliko slovo, Minimalno jedan broj \nMinimalno jedan specijalni karakter",
                                            )
                                          ]),
                                        ),
                                      ),
                                      InputField(
                                        name: "Telefon:",
                                        field: FormBuilderTextField(
                                          name: 'telefon',
                                          style: TextStyle(fontSize: 14),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText: 'Polje je obavezno'),
                                            FormBuilderValidators.phoneNumber(
                                                errorText:
                                                    "Očekivani format: +38761000000",
                                                regex:
                                                    RegExp(r'^\+\d{11,12}$')),
                                          ]),
                                        ),
                                      ),
                                      InputField(
                                        name: "Adresa:",
                                        field: FormBuilderTextField(
                                          name: 'adresa',
                                          style: TextStyle(fontSize: 14),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText: 'Polje je obavezno'),
                                          ]),
                                        ),
                                      ),
                                      _buildCountryInput(),
                                      _buildRoleInput()
                                    ]))
                              ]))))),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Odustani'),
              child: const Text('Odustani'),
            ),
            TextButton(
              onPressed: () async {
                if (_userFormKey.currentState?.saveAndValidate() ?? false) {
                  print("validno");
                  print(_userFormKey.currentState?.value);

                  Korisnik request =
                      Korisnik.fromJson(_userFormKey.currentState!.value);
                  print("request je");
                  print(request.ime);
                  try {
                    await _korisnikProvider.insert(request).then((value) =>
                        handleSuccess("Uspješno dodan novi korisnik"));
                  } on Exception catch (ex) {
                    handleException(ex);
                  }
                }
              },
              child: const Text('Potvrdi'),
            ),
          ],
        ),
      );
    } else {
      handleException(
          Exception("Morate imati ulogu Admin da biste dodali korisnika!"));
    }
  }

  _buildCountryInput() {
    return InkWell(
        child: IgnorePointer(
            child: SizedBox(
                height: 50,
                child: Column(children: [
                  InputField(
                      name: 'Država:',
                      field: FormBuilderTextField(
                        style: TextStyle(fontSize: 14),
                        name: "drzava",
                      )),
                ]))),
        onTap: () {
          showCountryPicker(
              context: context,
              onSelect: (Country country) {
                setState(() {
                  _userFormKey.currentState?.fields['drzava']
                      ?.didChange(country.name);
                });
              });
        });
  }

  _buildRoleInput() {
    return InputField(
      name: 'Uloga:',
      field: FormBuilderDropdown<int>(
        name: 'uloga',
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'Uloga je obavezna'),
        ]),
        items: _ulogeList
                ?.map(
                  (entry) => DropdownMenuItem(
                    value: entry.ulogaId,
                    child:
                        Text(entry.naziv ?? '', style: TextStyle(fontSize: 12)),
                  ),
                )
                .toList() ??
            [],
      ),
    );
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
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Dodaj novog korisnika',
              onPressed: () {
                addUser();
              },
            ),

            /* InputField(
              name: "",
              field: IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Dodaj novog korisnika',
                onPressed: () {
                  addUser();
                },
              ),
            ),*/
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
                    bool canAccess =
                        KorisnikGlobal.uloge?.contains("Admin") ?? false;
                    if (canAccess) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Potvrdite akciju'),
                          content: Text(
                              'Da li stvarno želite obrisati korisnika $korisnickoIme?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, 'Odustani'),
                              child: const Text('Odustani'),
                            ),
                            TextButton(
                              onPressed: () {
                                _korisnikProvider
                                    .delete(korisnikId)
                                    .then((value) {
                                  Navigator.pop(context, 'Potvrdi');
                                  _handleDeleteSuccess(context);
                                }).onError(
                                  (error, stackTrace) {
                                    Navigator.pop(context, 'Potvrdi');
                                    handleException(error as Exception);
                                  },
                                );
                              },
                              /* onPressed: () {
                                Navigator.pop(context, 'Potvrdi');
                                _korisnikProvider
                                    .delete(korisnikId)
                                    .then((value) => search());
                              },*/
                              child: const Text('Potvrdi'),
                            ),
                          ],
                        ),
                      );
                    } else
                      handleException(Exception(
                          "Morate imati ulogu Admin da biste obrisali korisnika!"));
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
      DataCell(
          Text("${e.created?.day}.${e.created?.month}.${e.created?.year}.")),
      DataCell(IconButton(
        icon: const Icon(Icons.remove_red_eye),
        color: Color.fromRGBO(44, 152, 240, 1),
        splashRadius: 20,
        hoverColor: Color.fromRGBO(224, 224, 224, 1),
        onPressed: () => onDetailsPressed(e.korisnikId!),
      )),
      DataCell(IconButton(
        icon: const Icon(Icons.delete),
        color: Color.fromRGBO(44, 152, 240, 1),
        splashRadius: 20,
        hoverColor: Color.fromRGBO(224, 224, 224, 1),
        onPressed: () => onDeletePressed(e.korisnikId!, e.korisnickoIme!),
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
