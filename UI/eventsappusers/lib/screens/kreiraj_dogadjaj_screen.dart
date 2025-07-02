import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

//import 'package:editable/editable.dart';
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
import 'package:eventsappusers/widgets/input_field.dart';
import 'package:eventsappusers/widgets/input_form_field.dart';
import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:eventsappusers/widgets/list_input_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';

import '../utils/formatting_util.dart';
import '../widgets/full_screen_image.dart';
import '../widgets/master_screen.dart';
import '../widgets/narudzba_master_screen.dart';
import '../widgets/photo_gallery.dart';

class KreirajDogadjajScreen extends StatefulWidget {
  KreirajDogadjajScreen({super.key});

  @override
  State<KreirajDogadjajScreen> createState() => _KreirajDogadjajScreenState();
}

class _KreirajDogadjajScreenState extends State<KreirajDogadjajScreen> {
  double _contentHeight = 0;

  TextEditingController nazivController = TextEditingController();
  TextEditingController lokacijaController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController opisController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController datumOdDateController = TextEditingController();
  TextEditingController datumDoDateController = TextEditingController();
  TextEditingController datumOdTimeController = TextEditingController();
  TextEditingController datumDoTimeController = TextEditingController();

  List<String> kategorije = [];
  final formKey = new GlobalKey<FormBuilderState>();
  final _eventFormKey = new GlobalKey<FormBuilderState>();
  final _karteFormKey = new GlobalKey<FormBuilderState>();
  List<dynamic>? _podkategorijeSelected = [];
  TimeOfDay timeOfDay = TimeOfDay.now();
  //Image _naslovna = Image.asset('assets/images/empty.jpg', fit: BoxFit.cover);
  ImageObj? _naslovna;
  ImageObj? _program;
  ImageObj? _lokacijaSlika;
  late KategorijeProvider _kategorijeProvider;
  late PodkategorijaProvider _podkategorijaProvider;
  late DobavljacProvider _dobavljacProvider;
  late DogadjajProvider _dogadjajProvider;
  late List<Kategorija>? _kategorijeList;
  late List<Podkategorija> _podkategorijeList = [];
  late List<dynamic>? _podkategorije;
  late List<DropdownMenuItem<int>> _kategorijeDropDownList;
  late List<DropdownMenuItem<int>> _dobavljaciDropdownList;
  late List<DropdownMenuItem<int>> _podkategorijeDropdownList;
  bool isLoading = true;
  bool podkategorijeLoaded = false;
  late List<Dobavljac>? _dobavljaciList = [];
  late List<String>? dobavljaci;
  final List<ImageObj> imageList = [];
  int? _selectedDobavljacId;
  List<Map<String, dynamic>> tipKarteList =
      []; // This list will hold saved data
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

  loadKategorije() async {
    await _kategorijeProvider.get().then((data) => {
          setState(() {
            _kategorijeList = data.result;
            _kategorijeDropDownList = data.result.map((k) {
              return DropdownMenuItem<int>(
                  value: k.kategorijaId, child: Text(k.naziv ?? 'not loaded'));
            }).toList();
            /*  kategorije =
                _kategorijeList!.map((k) => k.naziv.toString()).toList();*/
            kategorijeLoaded = true;
            handleLoading();
          })
        });
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: Text("OK"))
              ],
            ));
  }

  handleLoading() {
    if (kategorijeLoaded && dobavljaciLoaded) {
      setState(() {
        isLoading = false;
      });
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

  loadDobavljaci() async {
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

  kategorijaChanged(int? val) {
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

  /*_saveForm() {
    var form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivitiesResult = _podkategorijeSelected.toString();
      });
    }
  }*/

  Future<void> _selectDate(BuildContext context, String caller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        caller == 'datumOd'
            ? datumOdDateController.text = printDate(picked)
            : datumDoDateController.text = printDate(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, String caller) async {
    var picked = await showTimePicker(context: context, initialTime: timeOfDay);

    if (picked != null) {
      setState(() {
        caller == 'datumOd'
            ? datumOdTimeController.text = printTime(picked)
            : datumDoTimeController.text = printTime(picked);
      });
    }
  }

  handleDobavljacSelected(int? val) {
    if (val != null) {
      _selectedDobavljacId = val;
    }
    print("selected id je $_selectedDobavljacId");
  }

  /*int? findDobavljacIdByName(String? name) {
    if (name == null) return null;
    for (var dobavljac in _dobavljaciList!) {
      if (dobavljac.naziv == name) {
        return dobavljac.dobavljacId;
      }
    }
    return null;
  }*/

  Future getImage(Function(ImageObj) onImageSelected) async {
    File? file;
    String? base64Image;
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!);
      base64Image = base64Encode(file!.readAsBytesSync());
      final image = Image.file(
        file,
        fit: BoxFit.cover,
      );
      print("image: ${image}");
      print("baase64: $base64Image");
      onImageSelected(ImageObj(image, base64Image));
    }
  }

  void deleteImage(int index) {
    print(imageList.length);
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
                /*if (id != null) {
                    _galerijaProvider.delete(id).then((value) => {
                        setState(() {
                          galleryItems.removeAt(index);
                        })
                      });*/
                //} else {
                setState(() {
                  imageList.removeAt(index);
                });
                //}
              }

              print(imageList.length);
            },
            child: const Text('Potvrdi'),
          ),
        ],
      ),
    );
  }

  _objaviDogadjaj() async {
    print("uslo u objavljivanje");
    final isForm1Valid =
        _eventFormKey.currentState?.saveAndValidate(focusOnInvalid: false) ??
            false;
    final isForm2Valid =
        _karteFormKey.currentState?.saveAndValidate(focusOnInvalid: false) ??
            true;

    print("validnost $isForm1Valid $isForm2Valid");
      print("validnost druge ${  _karteFormKey.currentState?.saveAndValidate(focusOnInvalid: false)}");
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
        /* if (prodajaKarata != null && prodajaKarata) {
        if (tipKarteList.isEmpty) {
          setState(() {
            showTipoviError = true;
          });
          return;
        }*/
        if (isForm2Valid && tipKarteList.isNotEmpty) {
          sendRequest(true);
        }
        else {
        sendRequest(false);
      }
      } 
    
  }

  sendRequest(bool prodajaKarata) async {
    print("uslo u objavljivanje");
    var request = {};
    var request1 = Map.from(_eventFormKey.currentState!.value);
    if (prodajaKarata) {
      print("ukljucena prodaja");
      var request2 = Map.from(_karteFormKey.currentState!.value);
      request = {
        ...request1,
        ...request2,
      };
    } else {
      request = {...request1};
    }

  print("request ${request}");
    request.forEach((key, value) {
      if (value is DateTime) {
        request[key] = value.toIso8601String(); // Convert DateTime to String
      }
    });
    request['ProgramSlika'] = _program?.base64Image;
    request['Organizator'] = KorisnikGlobal.username;
    request['Galerija'] = formGalleryRequest();
    var latLong = await getLatLong(request['Lokacija']);
    print("latlong koji smo dobili $latLong");

    request['Latitude'] = latLong.latitude;
    request['Longitude'] = latLong.longitude;

    if (prodajaKarata) {
      request['LokacijaSlika'] = _lokacijaSlika?.base64Image;
      request['TipoviKarata'] = formTipoviKarataRequest();
    }
    print("request $request");

    try {
      await _dogadjajProvider.insert(request).then((value) =>
          handleSuccess("Uspješno ste poslali zahtjev za dodavanje događaja"));
    } on Exception catch (ex) {
      handleException(ex);
    }
  }

  List<String> formGalleryRequest() {
    List<String> gallery = [];
    imageList.forEach((img) => gallery.add(img.base64Image));
    return gallery;
  }

  List<Map<String, dynamic>> formTipoviKarataRequest() {
    List<Map<String, dynamic>> tipovi = [];

    tipKarteList?.forEach((tip) {
      tipovi.add({
        'Naziv': tip['tipKarte'],
        'Cijena': tip['cijena'],
        'NumerisanjeSjedista': tip['numerisanjeSjedista']
      });
    });

    return tipovi;
  }

  /*TIP KARTE */
  _addNewRow() {
    setState(() {
      rows.add(RowData(
          tipKarteController: TextEditingController(),
          cijenaController: TextEditingController(),
          numerisanjeSjedista: false));
    });
  }

  _removeRow(int index) {
    var row = rows[index];
    var tipKarte = row.tipKarteController.text;
    setState(() {
      tipKarteList.removeWhere((element) => element['tipKarte'] == tipKarte);
      rows.removeAt(index);
    });
    _updateRowIndex(index);
    print("list KARTI $tipKarteList");
    if (tipKarteList.isEmpty) {
      setState(() {
        showTipoviError = true;
      });
    }
  }

  _updateRowIndex(int index) {
    tipKarteList.forEach((e) => {
          if (e['rowsIndex'] > index) {e['rowsIndex'] -= 1}
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
            handleException(new Exception("Tip karte već postoji"));
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

      print("Updated tipKarteList: $tipKarteList");
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
                                // _buildForm(),
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
                                                                        ?.base64Image); // Update field value
                                                              });
                                                            }),
                                                            if (field
                                                                .hasError) // Display error text if validation fails
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
                                                  /* _dodajSliku((imageObj) {
                                                    setState(() {
                                                      _naslovna = imageObj;
                                                    });
                                                  }),*/
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
                                        child: Text(
                                          "Objavi",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat'),
                                        ),
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
                                            ))))
                              ],
                            )),
                      ),
                    )
                  ]);
                })
              ]))));
  }

  _buildHeader() {
    return Container(
        height: 50,
        child: Column(children: [
          HeadingWidget(text: "Kreiraj događaj"),
        ]));
  }

  _buildKarteForm() {
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
        /*  ListInputWidget(
          label: "Odaberite dobavljača karata:",
          valueList: dobavljaci ?? [],
          onChanged: handleDobavljacSelected,
        ),*/
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

  _dodajSliku(Function(ImageObj) onImageSelected) {
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

  _buildDatePicker() {
    var validateDate = FormBuilderValidators.compose([
      (value) {
        if (value == null) {
          return 'Polje je obavezno'; // Required field
        }
        return null;
      },
      (value) {
        if (value is DateTime) {
          print(_eventFormKey.currentState?.fields['DatumOd']?.value);
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
            CrossAxisAlignment.start, // Align columns at the top
        children: [
          Expanded(
            child: Container(
              height: 93, // Fixed height to ensure space for error text
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
          SizedBox(width: 4), // Add some spacing between the columns
          Expanded(
            child: Container(
              height: 93, // Fixed height to ensure space for error text
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

  /*_buildDatePicker() {
    var validateDate = FormBuilderValidators.compose([
      (value) {
        if (value == null) {
          return 'Polje je obavezno'; // Required field
        }
        return null;
      },
      (value) {
        if (value is DateTime) {
          print(_eventFormKey.currentState?.fields['DatumOd']?.value);
          if (value.isBefore(DateTime.now())) {
            return 'Datum mora biti u buducnosti';
          }
          if (value
              .isBefore(_eventFormKey.currentState?.fields['DatumOd']?.value)) {
            return 'Datum do mora biti poslije datuma od';
          }
        }
        return null;
      },
    ]);

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(children: [
          Expanded(
            child: /*InputFormField(
                  label: 'Od:',
                  field: FormBuilderDateTimePicker(
                    name: 'DatumOd',
                    decoration: InputDecoration(border: InputBorder.none),
                    format: DateFormat('dd.MM.yyyy. HH:mm'),
                  ))*/
                FieldWithValidate(
                    label: 'Datum od:',
                    field: FormBuilderDateTimePicker(
                        style: TextStyle(fontSize: 14),
                        name: "DatumOd",
                        decoration: inputField,
                        format: DateFormat('dd.MM.yyyy. HH:mm'),
                        validator: validateDate)),
          ),
          Expanded(
            child: /*InputFormField(
                  label: 'Do:',
                  field: FormBuilderDateTimePicker(
                    name: 'DatumDo',
                    decoration: InputDecoration(border: InputBorder.none),
                    format: DateFormat('dd.MM.yyyy. HH:mm'),
                  ))*/
                FieldWithValidate(
                    label: 'Datum do:',
                    field: FormBuilderDateTimePicker(
                        style: TextStyle(fontSize: 14),
                        name: "DatumDo",
                        decoration: inputField,
                        format: DateFormat('dd.MM.yyyy. HH:mm'),
                        validator: validateDate)),
          )
        ]));
  }*/

  _buildImage(Image? image, String tag) {
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

  _buildHeading(String naslov) {
    return Text(
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(54, 112, 232, 1),
            letterSpacing: 0.4,
            fontSize: 24),
        naslov);
  }

/*
   _buildSingleChoice() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Odaberite kategoriju",
                  style: TextStyle(
                      color: Color.fromRGBO(60, 71, 92, 1),
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      letterSpacing: 0.3),
                ),
              ),
              Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Color.fromRGBO(200, 200, 200, 1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  child: InputDecorator(
                      decoration: InputDecoration(
                          constraints: BoxConstraints(maxHeight: 35),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 164, 163, 163),
                              fontSize: 11.0),
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 11.0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20.0))),
                      isEmpty: _kategorijaSelected == '-',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          value: _kategorijaSelected,
                          isDense: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _kategorijaSelected = newValue ?? '-';
                              state.didChange(newValue);
                            });
                          },
                          items: kategorije.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 168, 168, 168)),
                              ),
                            );
                          }).toList(),
                        ),
                      )))
            ]));
      },
    );
  }*/
  FieldWithValidate _buildPodkategorije() {
    return FieldWithValidate(
        label: 'Odaberite podkategoriju:',
        field: FormBuilderDropdown(
            name: 'PodkategorijaId',
            decoration: inputField,
            items: _podkategorijeDropdownList

            /* onChanged: (int? newValue) {
                                                    kategorijaChanged(newValue);
                                                  }*/
            ));
  }

  /*_buildPodkategorije() {
    return FormBuilderField<List<dynamic>?>(
        name: 'PodkategorijeId',
        builder: (FormFieldState field) {
          return MultiSelectFormField(
            enabled: podkategorijeLoaded,
            autovalidate: AutovalidateMode.disabled,
            chipBackGroundColor: Colors.white,
            chipLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: const Color.fromRGBO(60, 71, 92, 1)),
            dialogTextStyle: TextStyle(fontWeight: FontWeight.w400),
            checkBoxActiveColor: Colors.blue,
            checkBoxCheckColor: Colors.white,
            dialogShapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              "Odaberite podkategoriju/e",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color.fromRGBO(60, 71, 92, 1),
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  letterSpacing: 0.3),
            ),
            validator: (value) {
              /*if (value == null || value.length == 0) {
                  return 'Odaberite jednu ili više opcija';
                }*/
              return null;
            },
            dataSource: getDataSource(),
            textField: 'display',
            valueField: 'value',
            okButtonLabel: 'OK',
            cancelButtonLabel: 'CANCEL',
            hintWidget: Text(
              'Odaberite jednu ili više opcija',
              style: TextStyle(
                  color: Color.fromRGBO(60, 71, 92, 1),
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  letterSpacing: 0.3),
            ),
            initialValue: _podkategorijeSelected,
            onSaved: (value) {
              if (value == null) return;
              field.didChange(value);
              setState(() {
                //  _podkategorijeSelected?.add(value);
                _podkategorijeSelected = value;
              });
              print(_podkategorijeSelected);
            },
          );
        });
  }*/

  _buildMultipleChoice() {
    return FormBuilder(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(0),
            child: MultiSelectFormField(
              enabled: podkategorijeLoaded,
              autovalidate: AutovalidateMode.disabled,
              chipBackGroundColor: Colors.white,
              chipLabelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: const Color.fromRGBO(60, 71, 92, 1)),
              dialogTextStyle: TextStyle(fontWeight: FontWeight.w400),
              checkBoxActiveColor: Colors.blue,
              checkBoxCheckColor: Colors.white,
              dialogShapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Text(
                "Odaberite podkategoriju/e",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(60, 71, 92, 1),
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    letterSpacing: 0.3),
              ),
              validator: (value) {
                /*if (value == null || value.length == 0) {
                  return 'Odaberite jednu ili više opcija';
                }*/
                return null;
              },
              dataSource: getDataSource(),
              textField: 'display',
              valueField: 'value',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'CANCEL',
              hintWidget: Text(
                'Odaberite jednu ili više opcija',
                style: TextStyle(
                    color: Color.fromRGBO(60, 71, 92, 1),
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    letterSpacing: 0.3),
              ),
              initialValue: _podkategorijeSelected,
              onSaved: (value) {
                if (value == null) return;

                setState(() {
                  //  _podkategorijeSelected?.add(value);
                  _podkategorijeSelected = value;
                });
                print(_podkategorijeSelected);
              },
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  /*_buildMultipleChoice() {
    return FormBuilderField(
      key: formKey,
      name: 'podkategorije',
      initialValue: _podkategorijeSelected,
      validator: (value) {
        // Add your custom validator logic here
        return null; // Replace with the validation message, if any
      },
      builder: (FormFieldState<List<dynamic>> field) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(0),
              child: MultiSelectFormField(
                enabled: podkategorijeLoaded,
                autovalidate: AutovalidateMode.disabled,
                chipBackGroundColor: Colors.white,
                chipLabelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: const Color.fromRGBO(60, 71, 92, 1),
                ),
                dialogTextStyle: TextStyle(fontWeight: FontWeight.w400),
                checkBoxActiveColor: Colors.blue,
                checkBoxCheckColor: Colors.white,
                dialogShapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                title: Text(
                  "Odaberite podkategoriju/e",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromRGBO(60, 71, 92, 1),
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
                dataSource: getDataSource(),
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                hintWidget: Text(
                  'Odaberite jednu ili više opcija',
                  style: TextStyle(
                    color: Color.fromRGBO(60, 71, 92, 1),
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    letterSpacing: 0.3,
                  ),
                ),
                initialValue: field.value,
                onSaved: (value) {
                  field.didChange(value); // Update FormBuilderField's value
                  print('Selected values: $value');
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }*/

  List<Map<String, dynamic>> getDataSource() {
    return _podkategorijeList
        .map((podkategorija) => {
              'display': podkategorija.naziv,
              'value': podkategorija.podkategorijaId
            })
        .toList();
  }

  _buildTipKarte() {
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

  /* _buildRows() {
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
                  // Tip karte input
                  Flexible(
                    flex: 2,
                    child: InputWidget(
                      label: 'Tip karte',
                      controller: rowData.tipKarteController,
                    ),
                  ),
                  SizedBox(width: 10),
                  // Cijena input
                  Flexible(
                    flex: 1,
                    child: InputWidget(
                      label: 'Cijena',
                      controller: rowData.cijenaController,
                      type: 'number',
                    ),
                  ),
                  SizedBox(width: 10),
                  // Cijena input
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
                    icon: Icon(Icons.save,
                        color: Color.fromRGBO(54, 112, 232, 1)),
                    onPressed: () => _saveRow(index), // Save the row
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
  }*/

  _buildRows() {
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
                  // Tip karte input
                  Flexible(
                    flex: 2,
                    child: InputWidget(
                      label: 'Tip karte',
                      controller: rowData.tipKarteController,
                    ),
                  ),
                  SizedBox(width: 10),
                  // Cijena input
                  Flexible(
                    flex: 1,
                    child: InputWidget(
                      label: 'Cijena',
                      controller: rowData.cijenaController,
                      type: 'number',
                    ),
                  ),
                  SizedBox(width: 10),
                  // Cijena input

                  IconButton(
                    icon: Icon(Icons.save,
                        color: Color.fromRGBO(54, 112, 232, 1)),
                    onPressed: () => _saveRow(index), // Save the row
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

  _buildDodajTipKarte() {
    print("pritisnuto");
    var tipKarteController = TextEditingController();
    var cijenaController = TextEditingController();
    return Row(
      children: [
        InputWidget(
          controller: tipKarteController,
          label: 'Tip karte',
        ),
        InputWidget(
          label: 'Cijena',
          controller: cijenaController,
          type: 'number',
        )
      ],
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
