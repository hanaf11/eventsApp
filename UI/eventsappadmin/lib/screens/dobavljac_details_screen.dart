import 'dart:convert';
import 'dart:io';

import 'package:eventsappadmin/models/dobavljac.dart';
import 'package:eventsappadmin/models/dogadjaj.dart';
import 'package:eventsappadmin/models/podkategorija.dart';
import 'package:eventsappadmin/providers/dobavljac_provider.dart';
import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/utils/style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../widgets/searchField.dart';

class DobavljacDetailsScreen extends StatefulWidget {
  Dobavljac? selectedDobavljac;
  Function() refresh;

  DobavljacDetailsScreen(
      {this.selectedDobavljac, required this.refresh, super.key});

  @override
  State<DobavljacDetailsScreen> createState() => _DobavljacDetailsScreenState();
}

class _DobavljacDetailsScreenState extends State<DobavljacDetailsScreen> {
  /* late ImageObj slika = widget.kategorijaSlika ??
      ImageObj(
          Image.asset(
            'assets/images/no_picture.jpg',
            fit: BoxFit.cover,
          ),
          null);*/
  final _formKey = GlobalKey<FormBuilderState>();
  final _podkategorijaFormKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  String? _slikaError;

  late DobavljacProvider _dobavljacProvider;
  late DogadjajProvider _dogadjajProvider;
  List<Dogadjaj>? _dogadjajList;
  //late PodkategorijaProvider podkategorijaProvider;

  _DobavljacDetailsScreenState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dobavljacProvider = context.read<DobavljacProvider>();
  }

  @override
  void initState() {
    super.initState();
    _dogadjajProvider = context.read<DogadjajProvider>();

    _initialValue = {
      'Naziv': widget.selectedDobavljac?.naziv,
      'Adresa': widget.selectedDobavljac?.adresa,
      'Telefon': widget.selectedDobavljac?.telefon,
      'Fax': widget.selectedDobavljac?.fax,
      'Web': widget.selectedDobavljac?.web,
      'Email': widget.selectedDobavljac?.email,
      'ZiroRacun': widget.selectedDobavljac?.ziroRacun,
      'Napomena': widget.selectedDobavljac?.napomena,
    };

    getDogadjaji();
  }

  getDogadjaji() async {
    var dogadjajiResult = await _dogadjajProvider
        .get(filter: {'DobavljacId': widget.selectedDobavljac?.dobavljacId});
    setState(() {
      _dogadjajList = dogadjajiResult.result;
    });
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

  /*checkCustomValidations() {
    if (slika.base64Image == null) {
      setState(
        () {
          _slikaError = "Slika je obavezna";
        },
      );
      _formKey.currentState?.fields['Slika']?.invalidate(_slikaError ?? '');
      return false;
    }
    return true;
  }*/

  /*getPodkategorije(int kategorijaId) async {
    var data = await podkategorijaProvider.get(filter: {
      'KategorijaId': kategorijaId,
    });
    setState(() {
      widget.podkategorijeList = data.result;
    });
  }*/

  /*deletePodkategorija(Podkategorija e) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Potvrdite akciju'),
        content:
            Text('Da li stvarno želite obrisati podkategoriju ${e.naziv}?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Odustani'),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Potvrdi');
              try {
                podkategorijaProvider.delete(e.podkategorijaId).then((value) {
                  getPodkategorije(e.kategorijaId);
                  widget.refresh(widget.selectedKategorija?.kategorijaId);
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

  /*savePodkategorija(int? id) async {
    if (_podkategorijaFormKey.currentState?.saveAndValidate() ?? false) {
      var request = Map.from(_podkategorijaFormKey.currentState!.value);
      request['KategorijaId'] = widget.selectedKategorija?.kategorijaId ?? 0;

      try {
        if (id == null) {
          await podkategorijaProvider.insert(request).then((value) =>
              handlePodkategorijaSuccess("Uspješno ste dodali podkategoriju"));
        } else {
          await podkategorijaProvider.update(id, request: request).then(
              (value) => handlePodkategorijaSuccess(
                  "Uspješno ste uredili podkategoriju"));
        }
      } on Exception catch (ex) {
        handleException(ex);
      }
    }
  }*/

  Future<void> showPodkategorijaDialog(Podkategorija? p) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: p != null
              ? Text("Uredi podkategoriju")
              : Text('Dodaj podkategoriju'),
          content: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: FormBuilder(
                    key: _podkategorijaFormKey,
                    child: ListBody(
                      children: <Widget>[
                        Row(children: [
                          InputField(
                            name: "Naziv:",
                            field: FormBuilderTextField(
                              name: 'Naziv',
                              initialValue: p?.naziv,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText:
                                        'Naziv podkategorije je obavezan')
                              ]),
                            ),
                          )
                        ]),
                      ],
                    ),
                  ))),
          actions: <Widget>[
            TextButton(
              style: buttonPrimary,
              child: const Text('Sačuvaj'),
              onPressed: () {
                // savePodkategorija(p?.podkategorijaId);
              },
            ),
          ],
        );
      },
    );
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
                      widget.refresh();
                    },
                    child: Text("OK"))
              ],
            ));
    if (value != null) {
      setState(() {
        widget.selectedDobavljac = value;
      });
    }
  }

  /*void handlePodkategorijaSuccess(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.refresh(widget.selectedKategorija?.kategorijaId);
                      getPodkategorije(
                          widget.selectedKategorija!.kategorijaId!);
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"))
              ],
            ));
  }*/

  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.selectedDobavljac == null
          ? Text("Dodaj dobavljača")
          : Text('Uredi dobavljača'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              initialValue: _initialValue,
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        InputField(
                          name: "Naziv:",
                          field: FormBuilderTextField(
                            name: 'Naziv',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: 'Naziv je obavezan')
                            ]),
                          ),
                        ),
                        InputField(
                          name: "Adresa:",
                          field: FormBuilderTextField(
                            name: 'Adresa',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: 'Adresa je obavezna')
                            ]),
                          ),
                        ),
                        InputField(
                          name: "Telefon:",
                          field: FormBuilderTextField(
                            name: 'Telefon',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: 'Telefon je obavezan'),
                              FormBuilderValidators.numeric(
                                  errorText: 'Dozvoljeni samo brojevi')
                            ]),
                          ),
                        ),
                        InputField(
                          name: "Fax:",
                          field: FormBuilderTextField(
                            name: 'Fax',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.numeric(
                                  errorText: 'Dozvoljeni samo brojevi')
                            ]),
                          ),
                        ),
                        InputField(
                          name: "Web:",
                          field: FormBuilderTextField(
                            name: 'Web',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.url(
                                  errorText: 'Url nije validan')
                            ]),
                          ),
                        ),
                        InputField(
                          name: "Email:",
                          field: FormBuilderTextField(
                            name: 'Email',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.email(
                                  errorText: 'Email nije validan')
                            ]),
                          ),
                        ),
                        InputField(
                          name: "Žiro račun:",
                          field: FormBuilderTextField(
                            name: 'ZiroRacun',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.numeric(
                                  errorText: 'Dozvoljeni samo brojevi')
                            ]),
                          ),
                        ),
                        InputField(
                          name: "Napomena:",
                          field: FormBuilderTextField(
                            name: 'Napomena',
                          ),
                        ),
                      ],
                    )),
                    SizedBox(height: 20),
                    Text(
                      "Događaji:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(34, 33, 33, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_dogadjajList != null && _dogadjajList!.isNotEmpty)
                      _buildDataListViewDogadjaji()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: buttonPrimary,
            onPressed: () async {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                var request = Map.from(_formKey.currentState!.value);
                print(request);

                try {
                  if (widget.selectedDobavljac == null) {
                    await _dobavljacProvider.insert(request).then((value) =>
                        handleDobavljacSuccess(
                            value, "Uspješno ste dodali dobavljača"));
                  } else {
                    await _dobavljacProvider
                        .update(widget.selectedDobavljac!.dobavljacId!,
                            request: request)
                        .then((value) => handleDobavljacSuccess(
                            null, "Uspješno ste uredili dobavljača"));
                  }
                } on Exception catch (ex) {
                  handleException(ex);
                }
              }
            },
            child: Text("Sačuvaj"),
          ),
        ),
        TextButton(
            onPressed: () => {Navigator.pop(context, 'Zatvori')},
            // style: buttonSecondary,
            child: const Text('Zatvori')),
      ],
    );
  }

  Expanded _buildDataListViewPodkategorije() {
    return Expanded(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      DataTable(showCheckboxColumn: false, columns: [
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
              'Uredi',
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
      ], rows: /*widget.podkategorijeList
                  ?.map((Podkategorija e) => DataRow(cells: [
                        DataCell(Text(
                          e.naziv ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataCell(IconButton(
                            icon: const Icon(Icons.edit),
                            color: Color.fromRGBO(44, 152, 240, 1),
                            splashRadius: 20,
                            hoverColor: Color.fromRGBO(224, 224, 224, 1),
                            onPressed: () {
                              showPodkategorijaDialog(e);
                            })),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          color: Color.fromRGBO(44, 152, 240, 1),
                          splashRadius: 20,
                          hoverColor: Color.fromRGBO(224, 224, 224, 1),
                          onPressed: () {
                            deletePodkategorija(e);
                          },
                        )),
                      ]))
                  .toList() ??*/
          []),
    ]));
  }

  Expanded _buildDataListViewDogadjaji() {
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
          ],
          rows: _dogadjajList
                  ?.map((Dogadjaj e) => DataRow(
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
                            DataCell(Text(
                              e.naziv?.toString() ?? "",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataCell(Text(e.datumOd != null
                                ? "${e.datumOd?.day}.${e.datumOd?.month}.${e.datumOd?.year}."
                                : "")),
                            DataCell(Text(e.lokacija?.toString() ?? "")),
                          ]))
                  .toList() ??
              []),
    ])));
  }
}
