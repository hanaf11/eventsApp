import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/providers/kategorija_provider.dart';
import 'package:eventsappadmin/providers/podkategorija_provider.dart';
import 'package:eventsappadmin/screens/dogadjaji_list_screen.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/kategorija.dart';
import '../models/podkategorija.dart';
import '../models/search_result.dart';

class DogadjajiDetailsScreen extends StatefulWidget {
  int? dogadjajId;
  DogadjajiDetailsScreen({this.dogadjajId, super.key});

  @override
  State<DogadjajiDetailsScreen> createState() => _DogadjajiDetailsScreenState();
}

class _DogadjajiDetailsScreenState extends State<DogadjajiDetailsScreen> {
  late KategorijaProvider _kategorijaProvider;
  late DogadjajProvider _dogadjajProvider;
  late PodkategorijaProvider _podkategorijaProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  SearchResult<Kategorija>? kategorijeResult;
  SearchResult<Podkategorija>? podkategorijeResult;
  bool isLoading = true;
  bool showBackButton = true;
  bool _deleted = false;
  int? kategorija;
  Dogadjaj? dogadjaj;
  Image _naslovna = Image.asset('assets/images/empty.jpg', fit: BoxFit.cover);

  @override
  void initState() {
    super.initState();

    /*_initialValue = {
      'naziv': widget.dogadjaj?.naziv,
      'opis': widget.dogadjaj?.opis,
      'program': widget.dogadjaj?.program,
      'kategorijaId': widget.dogadjaj?.kategorijaId,
      'podkategorijaId': widget.dogadjaj?.podkategorijaId,
      'lokacija': widget.dogadjaj?.lokacija,
      'datumOd': widget.dogadjaj?.datumOd,
      'datumDo': widget.dogadjaj?.datumDo,
      'website': widget.dogadjaj?.website,
      'organizator': widget.dogadjaj?.organizator
    };*/
    _kategorijaProvider = context.read<KategorijaProvider>();
    _dogadjajProvider = context.read<DogadjajProvider>();
    _podkategorijaProvider = context.read<PodkategorijaProvider>();
    initForm(widget.dogadjajId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  kategorijaChanged(value) async {
    setState(() {
      kategorija = value;
      _initialValue['podkategorijaId'] = null;
    });
    await _podkategorijaProvider
        .get(filter: {'kategorijaId': kategorija}).then((value) => setState(
              () {
                podkategorijeResult = value;
              },
            ));
  }

  void _handleDeleteSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Successful"),
          content: Text("Događaj je uspješno obrisan"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _deleted = true;
                });
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void handleDogadjajCreated(id) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Text("Uspješno ste dodali događaj!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("OK"))
              ],
            ));
    setState(() {
      widget.dogadjajId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        showBackButton: showBackButton,
        selectedIndex: 0,
        child: Expanded(
            child: SingleChildScrollView(
                child: Column(children: [
          isLoading ? Container() : _buildForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: _deleted
                        ? null
                        : () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Potvrdite akciju'),
                                content: Text(
                                    'Da li stvarno želite obrisati događaj ${dogadjaj?.naziv}?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Odustani'),
                                    child: const Text('Odustani'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Potvrdi');
                                      _dogadjajProvider
                                          .delete(dogadjaj!.dogadjajId!)
                                          .then((value) {
                                        _handleDeleteSuccess(context);
                                      });
                                    },
                                    child: const Text('Potvrdi'),
                                  ),
                                ],
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _deleted
                            ? Color.fromARGB(255, 90, 79, 81)
                            : Color.fromARGB(255, 198, 28, 53)),
                    child: Text("Obriši")),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _deleted
                              ? Color.fromARGB(255, 90, 79, 81)
                              : Color.fromARGB(255, 16, 104, 198)),
                      onPressed: _deleted
                          ? null
                          : () async {
                              _formKey.currentState?.saveAndValidate();
                              print(_formKey.currentState?.value);

                              var request =
                                  Map.from(_formKey.currentState!.value);

                              request['naslovna'] = _base64Image;
                              //request['naslovna'] = "";
                              request['datumOd'] =
                                  request['datumOd']?.toIso8601String();
                              request['datumDo'] =
                                  request['datumDo']?.toIso8601String();

                              try {
                                if (widget.dogadjajId == null) {
                                  await _dogadjajProvider
                                      .insert(request)
                                      .then((value) {
                                    handleDogadjajCreated(value.dogadjajId);
                                  });
                                } else {
                                  await _dogadjajProvider
                                      .update(widget.dogadjajId!,
                                          request: request)
                                      .then((value) {
                                    print(value);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: Text("Success"),
                                              content: Text(
                                                  "Uspješno ste uredili događaj!"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("OK"))
                                              ],
                                            ));
                                  });
                                }
                              } on Exception catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text("Error"),
                                          content: Text(e.toString()),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("OK"))
                                          ],
                                        ));
                              }
                            },
                      child: Text("Sačuvaj"))),
            ],
          )
        ]))));
  }

  Future initForm(dogadjajId) async {
    kategorijeResult = await _kategorijaProvider.get();
    if (dogadjajId != null) {
      dogadjaj = await _dogadjajProvider.getById(dogadjajId);
      podkategorijeResult = await _podkategorijaProvider
          .get(filter: {'kategorijaId': dogadjaj!.kategorijaId});
    }

    _initialValue = {
      'naziv': dogadjaj?.naziv,
      'opis': dogadjaj?.opis,
      'program': dogadjaj?.program,
      'kategorijaId': dogadjaj?.kategorijaId,
      'podkategorijaId': dogadjaj?.podkategorijaId,
      'lokacija': dogadjaj?.lokacija,
      'datumOd': dogadjaj?.datumOd,
      'datumDo': dogadjaj?.datumDo,
      'website': dogadjaj?.website,
      'organizator': dogadjaj?.organizator
    };

    setState(() {
      isLoading = false;
      _naslovna = dogadjaj != null && dogadjaj!.naslovna != null
          ? Image.memory(base64Decode(dogadjaj!.naslovna!), fit: BoxFit.cover)
          : _naslovna;
    });
  }

  Widget _buildForm() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: FormBuilder(
                key: _formKey,
                initialValue: _initialValue,
                child: Column(children: [
                  Row(children: [
                    _buildInputField(
                      "Naziv:",
                      FormBuilderTextField(
                        name: 'naziv',
                        onChanged: (val) {
                          // Print the text value write into TextField
                        },
                      ),
                    ),
                    _buildInputField(
                        "Lokacija:",
                        FormBuilderTextField(
                          name: 'lokacija',
                          onChanged: (val) {
                            // Print the text value write into TextField
                          },
                        ))
                  ]),
                  Row(
                    children: [
                      _buildInputField("Datum od:",
                          FormBuilderDateTimePicker(name: 'datumOd')),
                      _buildInputField("Datum do:",
                          FormBuilderDateTimePicker(name: 'datumDo'))
                    ],
                  ),
                  Row(
                    children: [
                      _buildInputField(
                          "Kategorija:",
                          FormBuilderDropdown<int>(
                            name: 'kategorijaId',
                            isExpanded: true,
                            /* decoration: InputDecoration(
                              suffix: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _formKey.currentState!.fields['kategorijaId']
                                      ?.reset();
                                },
                              ),
                            ),*/
                            onChanged: (value) {
                              kategorijaChanged(value);
                            },
                            items: kategorijeResult?.result
                                    .map((item) => DropdownMenuItem(
                                          alignment:
                                              AlignmentDirectional.center,
                                          value: item.kategorijaId,
                                          child: Text(item.naziv ?? ""),
                                        ))
                                    .toList() ??
                                [],
                          )),
                      _buildInputField(
                          "Podkategorije:",
                          FormBuilderDropdown<int>(
                            name: 'podkategorijaId',
                            isExpanded: true,
                            /* decoration: InputDecoration(
                              suffix: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _formKey.currentState!.fields['kategorijaId']
                                      ?.reset();
                                },
                              ),
                            ),*/
                            items: podkategorijeResult?.result
                                    .map((item) => DropdownMenuItem(
                                          alignment:
                                              AlignmentDirectional.center,
                                          value: item.podkategorijaId,
                                          child: Text(item.naziv ?? ""),
                                        ))
                                    .toList() ??
                                [],
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      _buildInputField(
                          "Website:",
                          FormBuilderTextField(
                            name: 'website',
                          )),
                      _buildInputField(
                          "Organizator:",
                          FormBuilderTextField(
                            name: 'organizator',
                          ))
                    ],
                  ),
                  Container(
                      height: 200,
                      child: Row(children: [
                        Expanded(
                            child: Column(children: [
                          _buildInputField(
                              "Naslovna:",
                              FormBuilderField(
                                  name: 'naslovna',
                                  builder: ((field) {
                                    return InputDecorator(
                                        decoration: InputDecoration(
                                            errorText: field.errorText),
                                        child: ListTile(
                                          leading: Icon(Icons.photo),
                                          title: Text("Select image"),
                                          trailing: Icon(Icons.file_upload),
                                          onTap: getImage,
                                        ));
                                  }))),
                          const SizedBox(height: 15),
                          buildNaslovna(),
                          const SizedBox(height: 15),
                        ])),
                        _buildInputField(
                            "Galerija:",
                            FormBuilderTextField(
                              name: 'galerija',
                            ))
                      ])),
                  Row(
                    children: [
                      _buildInputField(
                          "Program:",
                          FormBuilderTextField(
                            name: 'program',
                            maxLines: 5,
                          )),
                      _buildInputField(
                          "Opis:",
                          FormBuilderTextField(
                            name: 'opis',
                            maxLines: 5,
                          ))
                    ],
                  )
                  /*       Row(
                      children: [
                        Expanded(
                            child: FormBuilderDropdown<int>(
                          name: 'kategorijaId',
                          decoration: InputDecoration(
                            labelText: 'Kategorija',
                            suffix: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _formKey.currentState!.fields['kategorijaId']
                                    ?.reset();
                              },
                            ),
                            hintText: 'Odaberi kategoriju',
                          ),
                          items: kategorijeResult?.result
                                  .map((item) => DropdownMenuItem(
                                        alignment: AlignmentDirectional.center,
                                        value: item.kategorijaId,
                                        child: Text(item.naziv ?? ""),
                                      ))
                                  .toList() ??
                              [],
                        )),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                          child: FormBuilderField(
                        name: 'naslovna',
                        builder: ((field) {
                          return InputDecorator(
                              decoration: InputDecoration(
                                  label: Text("Odaberite sliku"),
                                  errorText: field.errorText),
                              child: ListTile(
                                leading: Icon(Icons.photo),
                                title: Text("Select image"),
                                trailing: Icon(Icons.file_upload),
                                onTap: getImage,
                              ));
                        }),
                      ))
                    ])*/
                ]))));
  }

  Widget _buildInputField(String name, Widget field) {
    return Expanded(
      child: Row(children: [
        Text(
          name,
          style: TextStyle(
              color: Color.fromRGBO(34, 33, 33, 1),
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(child: field),
        SizedBox(
          width: 50,
        ),
      ]),
    );
  }

  dynamic buildNaslovna() {
    return Container(
        height: 120,
        width: 350,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20), child: _naslovna));
  }

  File? _image;
  String? _base64Image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
      setState(() {
        _naslovna =
            _image != null ? Image.file(_image!, fit: BoxFit.cover) : _naslovna;
      });
    }
  }
}
