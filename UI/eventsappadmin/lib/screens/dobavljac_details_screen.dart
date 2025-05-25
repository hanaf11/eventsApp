import 'dart:convert';
import 'dart:io';

import 'package:eventsappadmin/models/dobavljac.dart';
import 'package:eventsappadmin/models/dogadjaj.dart';
import 'package:eventsappadmin/models/podkategorija.dart';
import 'package:eventsappadmin/providers/dobavljac_provider.dart';
import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
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

  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.selectedDobavljac == null
          ? Text("Dodaj dobavljača")
          : Text('Uredi dobavljača'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
              child: FormBuilder(
                  key: _formKey,
                  initialValue: _initialValue,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Shrink-wrap column
                      children: [
                        SizedBox(
                            height: 400,
                            child: Column(children: [
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
                            ])),
                        SizedBox(height: 20),
                        Text(
                          "Događaji:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(34, 33, 33, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        (_dogadjajList != null && _dogadjajList!.isNotEmpty)
                            ? _buildDataListViewDogadjaji()
                            : Text("Dobavljač nema događaja"),
                      ]))),
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
          onPressed: () => Navigator.pop(context, 'Zatvori'),
          child: const Text('Zatvori'),
        ),
      ],
    );
  }

  Widget _buildDataListViewDogadjaji() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.79, // Full-width table
            child: PaginatedDataTable(
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
              source: DogadjajiDataSource(dogadjaji: _dogadjajList ?? []),
              rowsPerPage: 5,
            )));
  }
}

class DogadjajiDataSource extends DataTableSource {
  final List<Dogadjaj> dogadjaji;

  DogadjajiDataSource({required this.dogadjaji});

  @override
  DataRow? getRow(int index) {
    if (index >= dogadjaji.length) return null;
    final e = dogadjaji[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
            Text(e.naziv ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(e.datumOd != null
            ? "${e.datumOd!.day}.${e.datumOd!.month}.${e.datumOd!.year}."
            : "")),
        DataCell(Text(e.lokacija ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dogadjaji.length;

  @override
  int get selectedRowCount => 0;
}
