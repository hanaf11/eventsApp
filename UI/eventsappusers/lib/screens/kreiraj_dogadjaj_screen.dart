import 'dart:convert';
import 'dart:io';
import 'package:eventsappusers/models/dobavljac.dart';
import 'package:eventsappusers/models/kategorija.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/models/podkategorija.dart';
import 'package:eventsappusers/providers/dobavljac_provider.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:eventsappusers/providers/kategorije_provider.dart';
import 'package:eventsappusers/providers/podkategorija_provider.dart';
import 'package:eventsappusers/screens/home_screen.dart';
import 'package:eventsappusers/utils/style_util.dart';
import 'package:eventsappusers/utils/util.dart';
import 'package:eventsappusers/widgets/field_with_validate.dart';
import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';
import '../utils/formatting_util.dart';
import '../widgets/full_screen_image.dart';
import '../widgets/master_screen.dart';
import '../widgets/photo_gallery.dart';

class KreirajDogadjajScreen extends StatefulWidget {
  const KreirajDogadjajScreen({super.key});

  @override
  State<KreirajDogadjajScreen> createState() => _KreirajDogadjajScreenState();
}

class _KreirajDogadjajScreenState extends State<KreirajDogadjajScreen> {
  double _contentHeight = 0;
  TextEditingController datumOdDateController = TextEditingController();
  TextEditingController datumDoDateController = TextEditingController();
  TextEditingController datumOdTimeController = TextEditingController();
  TextEditingController datumDoTimeController = TextEditingController();

  List<String> kategorije = [];
  final formKey = GlobalKey<FormBuilderState>();
  final _eventFormKey = GlobalKey<FormBuilderState>();
  final _karteFormKey = GlobalKey<FormBuilderState>();
  List<dynamic>? _podkategorijeSelected = [];
  TimeOfDay timeOfDay = TimeOfDay.now();
  ImageObj? _naslovna;
  ImageObj? _program;
  ImageObj? _lokacijaSlika;
  late KategorijeProvider _kategorijeProvider;
  late PodkategorijaProvider _podkategorijaProvider;
  late DobavljacProvider _dobavljacProvider;
  late DogadjajProvider _dogadjajProvider;
  late List<Kategorija>? _kategorijeList;
  late List<Podkategorija> _podkategorijeList = [];
  late List<DropdownMenuItem<int>> _kategorijeDropDownList;
  late List<DropdownMenuItem<int>> _dobavljaciDropdownList;
  late List<DropdownMenuItem<int>> _podkategorijeDropdownList;
  bool isLoading = true;
  bool podkategorijeLoaded = false;
  late List<Dobavljac>? _dobavljaciList = [];
  final List<ImageObj> imageList = [];
  int? _selectedDobavljacId;
  List<Map<String, dynamic>> tipKarteList =[];
  List<RowData> rows = [];
  int? selectedKategorija;
  bool kategorijeLoaded = false;
  bool dobavljaciLoaded = false;
  bool showTipoviError = false;
  String? showErrorText;

  @override
  void initState() {
    super.initState();
    _kategorijeProvider = context.read<KategorijeProvider>();
    _podkategorijaProvider = context.read<PodkategorijaProvider>();
    _dobavljacProvider = context.read<DobavljacProvider>();
    _dogadjajProvider = context.read<DogadjajProvider>();
    loadKategorije();
    loadDobavljaci();
  }

  Future<void> loadKategorije() async {
    await _kategorijeProvider.get().then((data) => {
          setState(() {
            _kategorijeList = data.result;
            _kategorijeDropDownList = data.result.map((k) {
              return DropdownMenuItem<int>(
                  value: k.kategorijaId, child: Text(k.naziv ?? 'not loaded'));
            }).toList();
            kategorijeLoaded = true;
            handleLoading();
          })
        });
  }

  void handleSuccess(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: Text("OK"))
              ],
            ));
  }

  void handleLoading() {
    if (kategorijeLoaded && dobavljaciLoaded) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleException(Exception e) {
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

  Future<void> loadDobavljaci() async {
    var filter = {"Active": true};
    await _dobavljacProvider.get(filter: filter).then((data) => {
          setState(() {
            _dobavljaciList = data.result;
            _dobavljaciDropdownList = data.result.map((d) {
              return DropdownMenuItem<int>(
                  value: d.dobavljacId, child: Text(d.naziv ?? 'not loaded'));
            }).toList();
            dobavljaciLoaded = true;
            handleLoading();
          })
        });
  }

  void kategorijaChanged(int? val) {
    if (val != null) {
      if (val != selectedKategorija) {
        setState(() {
          podkategorijeLoaded = false;
          selectedKategorija = val;
          _podkategorijeList = [];
          _podkategorijeSelected = [];
        });
        _podkategorijaProvider.get(filter: {'KategorijaId': val}).then((value) {
          setState(() {
            _podkategorijeList = value.result;
            _podkategorijeDropdownList = value.result.map((p) {
              return DropdownMenuItem<int>(
                  value: p.podkategorijaId,
                  child: Text(p.naziv ?? 'not loaded'));
            }).toList();
            podkategorijeLoaded = true;
          });
        });
      }
    }
  }

  void handleDobavljacSelected(int? val) {
    if (val != null) {
      _selectedDobavljacId = val;
    }
  }

  Future getImage(Function(ImageObj) onImageSelected) async {
    File? file;
    String? base64Image;
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!);
      base64Image = base64Encode(file.readAsBytesSync());
      final image = Image.file(
        file,
        fit: BoxFit.cover,
      );
      onImageSelected(ImageObj(image, base64Image));
    }
  }

  void deleteImage(int index) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Potvrdite akciju'),
        content: Text('Da li stvarno želite obrisati sliku?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Odustani'),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Potvrdi');
              if (index >= 0 && index < imageList.length) {
                setState(() {
                  imageList.removeAt(index);
                });
              }
            },
            child: const Text('Potvrdi'),
          ),
        ],
      ),
    );
  }

  Future<void> _objaviDogadjaj() async {
    final isForm1Valid =
        _eventFormKey.currentState?.saveAndValidate(focusOnInvalid: false) ??
            false;
    final isForm2Valid =
        _karteFormKey.currentState?.saveAndValidate(focusOnInvalid: false) ??
            true;

    var prodajaKarata = _eventFormKey.currentState?.value['ProdajaKarata'];
    if (prodajaKarata != null && prodajaKarata) {
      if (tipKarteList.isEmpty) {
        setState(() {
          showTipoviError = true;
        });
        return;
      }
    }

      if (isForm1Valid) {
        if (isForm2Valid && tipKarteList.isNotEmpty) {
          sendRequest(true);
        }
        else {
        sendRequest(false);
      }
      } 
    
  }

  Future<void> sendRequest(bool prodajaKarata) async {
    var request = {};
    var request1 = Map.from(_eventFormKey.currentState!.value);
    if (prodajaKarata) {
      var request2 = Map.from(_karteFormKey.currentState!.value);
      request = {
        ...request1,
        ...request2,
      };
    } else {
      request = {...request1};
    }

    request.forEach((key, value) {
      if (value is DateTime) {
        request[key] = value.toIso8601String();
      }
    });
    request['ProgramSlika'] = _program?.base64Image;
    request['Organizator'] = KorisnikGlobal.username;
    request['Galerija'] = formGalleryRequest();
    var latLong = await getLatLong(request['Lokacija']);
    request['Latitude'] = latLong.latitude;
    request['Longitude'] = latLong.longitude;

    if (prodajaKarata) {
      request['LokacijaSlika'] = _lokacijaSlika?.base64Image;
      request['TipoviKarata'] = formTipoviKarataRequest();
    }

    try {
      await _dogadjajProvider.insert(request).then((value) =>
          handleSuccess("Uspješno ste poslali zahtjev za dodavanje događaja"));
    } on Exception catch (ex) {
      handleException(ex);
    }
  }

  List<String> formGalleryRequest() {
    List<String> gallery = [];
    for (var img in imageList) {
      gallery.add(img.base64Image);
    }
    return gallery;
  }

  List<Map<String, dynamic>> formTipoviKarataRequest() {
    List<Map<String, dynamic>> tipovi = [];

    tipKarteList.forEach((tip) {
      tipovi.add({
        'Naziv': tip['tipKarte'],
        'Cijena': tip['cijena'],
        'NumerisanjeSjedista': tip['numerisanjeSjedista']
      });
    });

    return tipovi;
  }

  /*TIP KARTE */
  void _addNewRow() {
    setState(() {
      rows.add(RowData(
          tipKarteController: TextEditingController(),
          cijenaController: TextEditingController(),
          numerisanjeSjedista: false));
    });
  }

  void _removeRow(int index) {
    var row = rows[index];
    var tipKarte = row.tipKarteController.text;
    setState(() {
      tipKarteList.removeWhere((element) => element['tipKarte'] == tipKarte);
      rows.removeAt(index);
    });
    _updateRowIndex(index);
    if (tipKarteList.isEmpty) {
      setState(() {
        showTipoviError = true;
      });
    }
  }

  void _updateRowIndex(int index) {
    tipKarteList.forEach((e) {
          if (e['rowsIndex'] > index) {e['rowsIndex'] -= 1;};
        });
  }

  void _saveRow(int index) {
    var tipKarte = rows[index].tipKarteController.text;
    var cijena = rows[index].cijenaController.text;
    var numerisanjeSjedista = rows[index].numerisanjeSjedista;

    if (tipKarte.isNotEmpty && cijena.isNotEmpty) {
      setState(() {
        showErrorText = null;
        var existingIndex =
            tipKarteList.indexWhere((element) => element['rowsIndex'] == index);

        if (existingIndex != -1) {
          tipKarteList[existingIndex] = {
            'tipKarte': tipKarte,
            'cijena': cijena,
            'rowsIndex': index,
            'numerisanjeSjedista': numerisanjeSjedista
          };
        } else {
          var tipKarteExists = tipKarteList
              .indexWhere((element) => element['tipKarte'] == tipKarte);
          if (tipKarteExists != -1) {
            handleException(Exception("Tip karte već postoji"));
            return;
          }

          tipKarteList.add({
            'tipKarte': tipKarte,
            'cijena': cijena,
            'rowsIndex': index,
            'numerisanjeSjedista': numerisanjeSjedista
          });
        }
      });

      if (tipKarteList.isNotEmpty) {
        setState(() {
          showTipoviError = false;
        });
      }
    } else if (tipKarte.isEmpty) {
      setState(() {
        showErrorText = "Naziv je obavezan";
      });
    } else if (cijena.isEmpty) {
      setState(() {
        showErrorText = "Cijena je obavezna";
      });
    }
  }

  _KreirajDogadjajScreenState();

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        selectedIndex: -1,
        showBackButton: true,
        showAppBar: true,
        child: isLoading
            ? const Expanded(child: Center(child: CircularProgressIndicator()))
            : Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
                LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _contentHeight = constraints.maxHeight;
                      });
                    }
                  });

                  return Column(children: [
                    _buildHeader(),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 191, 190, 190),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(4, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                FormBuilder(
                                    key: _eventFormKey,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FieldWithValidate(
                                              label: 'Naziv:',
                                              field: FormBuilderTextField(
                                                style: TextStyle(fontSize: 14),
                                                name: "Naziv",
                                                decoration: inputField,
                                                validator: FormBuilderValidators
                                                    .compose([
                                                  FormBuilderValidators.required(
                                                      errorText:
                                                          'Polje je obavezno')
                                                ]),
                                              )),
                                          FieldWithValidate(
                                              label: 'Lokacija:',
                                              field: FormBuilderTextField(
                                                style: TextStyle(fontSize: 14),
                                                name: "Lokacija",
                                                decoration: inputField,
                                                validator: FormBuilderValidators
                                                    .compose([
                                                  FormBuilderValidators.required(
                                                      errorText:
                                                          'Polje je obavezno')
                                                ]),
                                              )),
                                          _buildDatePicker(),
                                          FieldWithValidate(
                                              label: 'Odaberite kategoriju:',
                                              field: FormBuilderDropdown(
                                                  name: 'KategorijaId',
                                                  decoration: inputField,
                                                  items:
                                                      _kategorijeDropDownList,
                                                  validator:
                                                      FormBuilderValidators
                                                          .compose([
                                                    FormBuilderValidators.required(
                                                        errorText:
                                                            'Polje je obavezno')
                                                  ]),
                                                  onChanged: (int? newValue) {
                                                    kategorijaChanged(newValue);
                                                  })),
                                          if (podkategorijeLoaded == true)
                                            _buildPodkategorije(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FieldWithValidate(
                                              label: 'Website:',
                                              field: FormBuilderTextField(
                                                style: TextStyle(fontSize: 14),
                                                name: "Website",
                                                decoration: inputField,
                                              )),
                                          FieldWithValidate(
                                              label: 'Opis:',
                                              field: FormBuilderTextField(
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  name: "Opis",
                                                  decoration: inputField,
                                                  minLines: 5,
                                                  maxLines: 10,
                                                  validator:
                                                      FormBuilderValidators
                                                          .compose([
                                                    FormBuilderValidators
                                                        .required()
                                                  ]))),
                                          FieldWithValidate(
                                              label: 'Program:',
                                              field: FormBuilderTextField(
                                                style: TextStyle(fontSize: 14),
                                                name: "Program",
                                                decoration: inputField,
                                                minLines: 5,
                                                maxLines: 10,
                                              )),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 8),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Program slika:',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              60, 71, 92, 1),
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 15,
                                                          letterSpacing: 0.3),
                                                    ),
                                                    _dodajSliku((imageObj) {
                                                      setState(() {
                                                        _program = imageObj;
                                                      });
                                                    }),
                                                  ])),
                                          _buildImage(
                                              _program?.image, 'programSlika'),
                                          SizedBox(height: 15),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Naslovna slika:',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            60, 71, 92, 1),
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 15,
                                                        letterSpacing: 0.3),
                                                  ),
                                                  FormBuilderField(
                                                      name: "Naslovna",
                                                      validator:
                                                          FormBuilderValidators
                                                              .compose([
                                                        FormBuilderValidators
                                                            .required(
                                                                errorText:
                                                                    'Polje je obavezno')
                                                      ]),
                                                      builder: (FormFieldState<
                                                              dynamic>
                                                          field) {
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            _dodajSliku(
                                                                (imageObj) {
                                                              setState(() {
                                                                _naslovna =
                                                                    imageObj;
                                                                field.didChange(
                                                                    _naslovna
                                                                        ?.base64Image);
                                                              });
                                                            }),
                                                            if (field
                                                                .hasError)
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 5),
                                                                child: Text(
                                                                  field.errorText ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        );
                                                      })
                                                ],
                                              )),
                                          _buildImage(_naslovna?.image,
                                              'naslovnaSlika'),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Galerija:',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            60, 71, 92, 1),
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 15,
                                                        letterSpacing: 0.3),
                                                  ),
                                                  _dodajSliku((imageObj) {
                                                    setState(() {
                                                      imageList.add(imageObj);
                                                    });
                                                  }),
                                                ],
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          PhotoGallery(
                                              imageList: imageList,
                                              delete: true,
                                              onDelete: deleteImage),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          FormBuilderCheckbox(
                                            name: "ProdajaKarata",
                                            title: Text(
                                              "Uključena prodaja karata",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    60, 71, 92, 1),
                                                fontSize: 15,
                                                letterSpacing: 0.3,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                          ),
                                          SizedBox(height: 20),
                                        ])),
                                if (_eventFormKey.currentState
                                        ?.fields['ProdajaKarata']?.value ==
                                    true)
                                  FormBuilder(
                                      key: _karteFormKey,
                                      child: _buildKarteForm()),
                                SizedBox(height: 20),
                                Center(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          await _objaviDogadjaj();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 100, vertical: 10),
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            )),
                                        child: Text(
                                          "Objavi",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat'),
                                        )))
                              ],
                            )),
                      ),
                    )
                  ]);
                })
              ]))));
  }

  SizedBox _buildHeader() {
    return SizedBox(
        height: 50,
        child: Column(children: [
          HeadingWidget(text: "Kreiraj događaj"),
        ]));
  }

  Column _buildKarteForm() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Slika lokacije:',
                  style: TextStyle(
                      color: Color.fromRGBO(60, 71, 92, 1),
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      letterSpacing: 0.3),
                ),
                _dodajSliku((imageObj) {
                  setState(() {
                    _lokacijaSlika = imageObj;
                  });
                }),
              ],
            )),
        _buildImage(_lokacijaSlika?.image, 'lokacijaSlika'),
        SizedBox(height: 5),
        FieldWithValidate(
            label: 'Odaberite dobavljača karata:',
            field: FormBuilderDropdown(
                name: 'DobavljacId',
                decoration: inputField,
                items: _dobavljaciDropdownList,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Polje je obavezno')
                ]),
                onChanged: (int? newValue) {
                  handleDobavljacSelected(newValue);
                })),
        SizedBox(height: 5),
        Container(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: _buildTipKarte()))
      ],
    );
  }

  Align _dodajSliku(Function(ImageObj) onImageSelected) {
    return Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          child: Text(
            "+ Dodajte sliku",
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Montserrat',
                letterSpacing: 0.3,
                color: Color.fromRGBO(54, 112, 232, 1)),
          ),
          onTap: () {
            getImage(onImageSelected);
          },
        ));
  }

  Padding _buildDatePicker() {
    var validateDate = FormBuilderValidators.compose([
      (value) {
        if (value == null) {
          return 'Polje je obavezno';
        }
        return null;
      },
      (value) {
        if (value is DateTime) {
          if (value.isBefore(DateTime.now())) {
            return 'Datum mora biti u buducnosti';
          }
          if (value
              .isBefore(_eventFormKey.currentState?.fields['DatumOd']?.value)) {
            return 'Mora biti poslije početnog datuma';
          }
        }
        return null;
      },
    ]);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: 93,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldWithValidate(
                    label: 'Datum od:',
                    field: FormBuilderDateTimePicker(
                      style: TextStyle(fontSize: 14),
                      name: "DatumOd",
                      decoration: inputField,
                      format: DateFormat('dd.MM.yyyy. HH:mm'),
                      validator: validateDate,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: SizedBox(
              height: 93,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldWithValidate(
                    label: 'Datum do:',
                    field: FormBuilderDateTimePicker(
                      style: TextStyle(fontSize: 14),
                      name: "DatumDo",
                      decoration: inputField,
                      format: DateFormat('dd.MM.yyyy. HH:mm'),
                      validator: validateDate,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  StatelessWidget _buildImage(Image? image, String tag) {
    return image != null
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(tag: tag, image: image),
                ),
              );
            },
            child: Container(
                height: 140,
                width: 400,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), child: image)))
        : Container();
  }

  FieldWithValidate _buildPodkategorije() {
    return FieldWithValidate(
        label: 'Odaberite podkategoriju:',
        field: FormBuilderDropdown(
            name: 'PodkategorijaId',
            decoration: inputField,
            items: _podkategorijeDropdownList
            ));
  }

  Column _buildTipKarte() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'Tipovi karata',
            style: TextStyle(
                color: Color.fromRGBO(60, 71, 92, 1),
                fontFamily: 'Montserrat',
                fontSize: 15,
                letterSpacing: 0.3),
          ),
          InkWell(
              child: Text(
                "+ Dodaj tip karte",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    letterSpacing: 0.3,
                    color: Color.fromRGBO(54, 112, 232, 1)),
              ),
              onTap: () {
                _addNewRow();
              })
        ]),
        showTipoviError
            ? Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Tipovi karata su obavezni",
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ))
            : Container(),
        SizedBox(
          height: 20,
        ),
        _buildRows()
      ],
    );
  }


  Column _buildRows() {
    return Column(
      children: rows.asMap().entries.map((entry) {
        int index = entry.key;
        RowData rowData = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: InputWidget(
                      label: 'Tip karte',
                      controller: rowData.tipKarteController,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: InputWidget(
                      label: 'Cijena',
                      controller: rowData.cijenaController,
                      type: 'number',
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.save,
                        color: Color.fromRGBO(54, 112, 232, 1)),
                    onPressed: () => _saveRow(index),
                  ),
                ],
              ),
              showErrorText != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(showErrorText!,
                          style: TextStyle(color: Colors.red, fontSize: 12)))
                  : Container(),
              Row(
                children: [
                  Text("Uključeno numerisanje sjedišta: ",
                      style: TextStyle(
                          color: Color.fromRGBO(60, 71, 92, 1),
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          letterSpacing: 0.3)),
                  Flexible(
                    flex: 1,
                    child: Checkbox(
                      value: rowData.numerisanjeSjedista,
                      onChanged: (bool? value) {
                        setState(() {
                          rowData.numerisanjeSjedista =
                              value ?? rowData.numerisanjeSjedista;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,
                        color: Color.fromRGBO(54, 112, 232, 1)),
                    onPressed: () => _removeRow(index),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class RowData {
  TextEditingController tipKarteController;
  TextEditingController cijenaController;
  bool numerisanjeSjedista = false;

  RowData(
      {required this.tipKarteController,
      required this.cijenaController,
      required this.numerisanjeSjedista});
}
