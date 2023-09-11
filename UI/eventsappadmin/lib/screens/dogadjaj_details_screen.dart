import 'dart:convert';
import 'dart:io';

import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/providers/kategorija_provider.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/kategorija.dart';
import '../models/search_result.dart';

class DogadjajiDetailsScreen extends StatefulWidget {
  //TBD hocu li zvat api ili proslijedit objekat (V10P4)
  Dogadjaj? dogadjaj;
  DogadjajiDetailsScreen({this.dogadjaj, super.key});

  @override
  State<DogadjajiDetailsScreen> createState() => _DogadjajiDetailsScreenState();
}

class _DogadjajiDetailsScreenState extends State<DogadjajiDetailsScreen> {
  late KategorijaProvider _kategorijaProvider;
  late DogadjajProvider _dogadjajProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  SearchResult<Kategorija>? kategorijeResult;
  bool isLoading = true;
  bool showBackButton = true;

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'naziv': widget.dogadjaj?.naziv,
      'opis': widget.dogadjaj?.opis,
      'program': widget.dogadjaj?.program,
      'kategorijaId': widget.dogadjaj?.kategorijaId
    };
    _kategorijaProvider = context.read<KategorijaProvider>();
    _dogadjajProvider = context.read<DogadjajProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        showBackButton: showBackButton,
        selectedIndex: 0,
        child: Expanded(
            child: Column(children: [
          isLoading ? Container() : _buildForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () async {
                        _formKey.currentState?.saveAndValidate();
                        print(_formKey.currentState?.value);

                        var request = Map.from(_formKey.currentState!.value);
                        request['naslovna'] = _base64Image;
                        print(request['naslovna']);

                        try {
                          if (widget.dogadjaj == null) {
                            await _dogadjajProvider.insert(request);
                          } else {
                            await _dogadjajProvider.update(
                                widget.dogadjaj!.dogadjajId!,
                                request: request);
                          }
                        } on Exception catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
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
                      child: Text("Sačuvaj")))
            ],
          )
        ])));
  }

  Future initForm() async {
    kategorijeResult = await _kategorijaProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  Expanded _buildForm() {
    return Expanded(
        child: FormBuilder(
            key: _formKey,
            initialValue: _initialValue,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Naziv:"),
                      name: 'naziv',
                      onChanged: (val) {
                        print(val); // Print the text value write into TextField
                      },
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Opis:"),
                      name: 'opis',
                      onChanged: (val) {
                        print(val); // Print the text value write into TextField
                      },
                    )),
                  ],
                ),
                Row(
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
                ])
              ],
            )));
  }

  File? _image;
  String? _base64Image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }
}
