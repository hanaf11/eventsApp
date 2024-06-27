import 'dart:convert';
import 'dart:io';

import 'package:eventsappadmin/models/kategorija.dart';
import 'package:eventsappadmin/models/podkategorija.dart';
import 'package:eventsappadmin/providers/kategorija_provider.dart';
import 'package:eventsappadmin/providers/podkategorija_provider.dart';
import 'package:eventsappadmin/utils/style_util.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../widgets/searchField.dart';

class KategorijeDetailsScreen extends StatefulWidget {
  Kategorija? selectedKategorija;
  ImageObj? kategorijaSlika;
  Function(ImageObj)? imageChanged;
  Function(int?) refresh;
  String? base64Image;
  List<Podkategorija>? podkategorijeList;

  KategorijeDetailsScreen(
      {this.selectedKategorija,
      this.kategorijaSlika,
      this.imageChanged,
      this.base64Image,
      required this.refresh,
      this.podkategorijeList,
      super.key});

  @override
  State<KategorijeDetailsScreen> createState() =>
      _KategorijeDetailsScreenState();
}

class _KategorijeDetailsScreenState extends State<KategorijeDetailsScreen>
    implements Clearable {
  late ImageObj slika = widget.kategorijaSlika ??
      ImageObj(
          Image.asset(
            'assets/images/no_picture.jpg',
            fit: BoxFit.cover,
          ),
          null);
  final _formKey = GlobalKey<FormBuilderState>();
  final _podkategorijaFormKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  String? _slikaError;

  late KategorijaProvider kategorijaProvider;
  late PodkategorijaProvider podkategorijaProvider;

  _KategorijeDetailsScreenState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    kategorijaProvider = context.read<KategorijaProvider>();
    podkategorijaProvider = context.read<PodkategorijaProvider>();
  }

  @override
  void initState() {
    super.initState();

    _initialValue = {
      'Naziv': widget.selectedKategorija?.naziv,
      'Opis': widget.selectedKategorija?.opis,
    };
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

  checkCustomValidations() {
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
  }

  getPodkategorije(int kategorijaId) async {
    var data = await podkategorijaProvider.get(filter: {
      'KategorijaId': kategorijaId,
    });
    setState(() {
      widget.podkategorijeList = data.result;
    });
  }

  deletePodkategorija(Podkategorija e) {
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
  }

  savePodkategorija(int? id) async {
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
  }

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
                savePodkategorija(p?.podkategorijaId);
              },
            ),
          ],
        );
      },
    );
  }

  void handleKategorijaSuccess(Kategorija? value, String msg) {
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
                    },
                    child: Text("OK"))
              ],
            ));
    if (value != null) {
      setState(() {
        widget.selectedKategorija = value;
      });
    }
  }

  void handlePodkategorijaSuccess(String msg) {
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
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Uredi kategoriju'),
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
                    Container(
                        height: 120,
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
                              name: "Opis:",
                              field: FormBuilderTextField(
                                name: 'Opis',
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 20),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Slika: ",
                          style: TextStyle(
                            color: Color.fromRGBO(34, 33, 33, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        FormBuilderField(
                            name: "Slika",
                            builder: (FormFieldState<dynamic> field) {
                              return SizedBox(
                                  width: 120,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                        errorText: _slikaError,
                                        border: InputBorder.none),
                                    child: InkWell(
                                      onTap: () async {
                                        var imageObj = await getImage();
                                        setState(() {
                                          slika = imageObj;
                                          widget.base64Image =
                                              imageObj.base64Image;
                                          _slikaError = null;
                                          _formKey.currentState?.fields['Slika']
                                              ?.validate();
                                        });
                                        widget.imageChanged!(imageObj);
                                      },
                                      //ako mi bude trebalo radi validacije pogledati v11 custom form builder
                                      child: Text(
                                        "+ Promijeni sliku",
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 0.3,
                                          color:
                                              Color.fromRGBO(54, 112, 232, 1),
                                        ),
                                      ),
                                    ),
                                  ));
                            }),

                        /*InkWell(
                          onTap: () async {
                            var imageObj = await getImage();
                            setState(() {
                              slika = imageObj;
                              widget.base64Image = imageObj.base64Image;
                            });
                            widget.imageChanged!(imageObj);
                          },
                          //ako mi bude trebalo radi validacije pogledati v11 custom form builder
                          child: Text(
                            "+ Promijeni sliku",
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 0.3,
                              color: Color.fromRGBO(54, 112, 232, 1),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 270,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: slika.image,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Podkategorije:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromRGBO(34, 33, 33, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showPodkategorijaDialog(null);
                            },
                            child: Text(
                              "+ Dodaj podkategoriju",
                              style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 0.3,
                                color: Color.fromRGBO(54, 112, 232, 1),
                              ),
                            ),
                          ),
                        ]),
                    if (widget.podkategorijeList != null &&
                        widget.podkategorijeList!.isNotEmpty)
                      _buildDataListViewPodkategorije()
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
              if ((_formKey.currentState?.saveAndValidate() ?? false) &&
                  await checkCustomValidations()) {
                var request = Map.from(_formKey.currentState!.value);
                request['Slika'] = slika.base64Image ?? getDefaultImage();

                try {
                  if (widget.selectedKategorija == null) {
                    await kategorijaProvider.insert(request).then((value) =>
                        handleKategorijaSuccess(
                            value, "Uspješno ste dodali kategoriju"));
                  } else {
                    await kategorijaProvider
                        .update(widget.selectedKategorija!.kategorijaId!,
                            request: request)
                        .then((value) => handleKategorijaSuccess(
                            null, "Uspješno ste uredili kategoriju"));
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
            child: const Text('Zatvori'),
            style: buttonSecondary),
      ],
    );
  }

  Expanded _buildDataListViewPodkategorije() {
    return Expanded(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      DataTable(
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
          ],
          rows: widget.podkategorijeList
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
                  .toList() ??
              []),
    ]));
  }

  Future<ImageObj> getImage() async {
    File? file;

    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!);
      String base64Image = base64Encode(file!.readAsBytesSync());

      final image = Image.file(
        file,
        fit: BoxFit.cover,
      );
      var imageObj = ImageObj(image, base64Image);
      return imageObj;
    } else {
      return slika;
    }
  }
}
