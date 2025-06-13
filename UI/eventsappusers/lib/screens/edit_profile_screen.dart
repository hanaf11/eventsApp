import 'dart:convert';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:eventsappusers/models/korisnik.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/providers/korisnik_provider.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:eventsappusers/utils/style_util.dart';
import 'package:eventsappusers/utils/util.dart';
import 'package:eventsappusers/widgets/field_with_validate.dart';
import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../widgets/dogadjaj_vertical.dart';
import '../widgets/full_screen_image.dart';
import '../widgets/master_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback onProfileUpdated;
  EditProfileScreen({required this.onProfileUpdated, super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ImageObj _profilna = ImageObj(
      imageFromBase64String(KorisnikGlobal.slika), KorisnikGlobal.slika ?? "");
  bool _imageUpdated = false;
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController newPassConfirmController = TextEditingController();
  late KorisnikProvider _korisnikProvider;
  late Korisnik _korisnik;
  DateTime created = DateTime.now();
  final _formKey = new GlobalKey<FormBuilderState>();
  bool isLoading = true;
  _EditProfileScreenState();

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    loadKorisnik();
  }

  loadKorisnik() async {
    await _korisnikProvider.getById(KorisnikGlobal.korisnikId).then((value) {
      setState(() {
        _korisnik = value;
        isLoading = false;
      });
    });
  }

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

  _saveProfilePicture() async {
    try {
      await _korisnikProvider.updateProfilePicture(
          KorisnikGlobal.korisnikId!, _profilna.base64Image);
      KorisnikGlobal.slika = _profilna.base64Image;
      widget.onProfileUpdated();
      _showDialog("Success", "Profilna slika je uspješno spremljena!");
    } catch (error) {
      _showDialog(
          "Success", "Greška prilikom editovanja slike profila: $error");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  editKorisnik() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      print(_formKey.currentState?.value);

      Korisnik request = Korisnik.fromJson(_formKey.currentState!.value);
      request.status = true;
      try {
        setState(() {
          isLoading = true;
        });
        await _korisnikProvider
            .update(KorisnikGlobal.korisnikId!, request: request)
            .then((value) {
          setState(() {
            isLoading = false;
            _korisnik = value;
            KorisnikGlobal.ime = _korisnik.ime;
            KorisnikGlobal.lokacija = _korisnik.adresa;
          });

          _showDialog("Success", "Uspješno ste promijenili podatke");
          widget.onProfileUpdated();
        });
      } on Exception catch (ex) {
        _showDialog("Error", ex.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        selectedIndex: -1,
        showBackButton: true,
        showAppBar: true,
        child: Expanded(
            child: isLoading
                ? Container(
                    child: Center(child: const CircularProgressIndicator()))
                : Stack(children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                            child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                        tag: 'profilnaSlika',
                                        image: _profilna.image),
                                  ),
                                );
                              },
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(48),
                                  child: _profilna.image,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                                child: Text(
                                  "Promijeni sliku",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Montserrat',
                                      letterSpacing: 0.3,
                                      color: Color.fromRGBO(54, 112, 232, 1)),
                                ),
                                onTap: () {
                                  getImage((image) {
                                    setState(() {
                                      _profilna = image;
                                      _imageUpdated = true;
                                    });
                                  });
                                }),
                            _imageUpdated
                                ? IconButton(
                                    onPressed: () {
                                      _saveProfilePicture();
                                    },
                                    icon: Icon(
                                      Icons.save,
                                      size: 20,
                                      color: Color.fromRGBO(54, 112, 232, 1),
                                    ))
                                : Container(),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildHeading('Podaci o korisniku'),
                                        IconButton(
                                            onPressed: () {
                                              editKorisnik();
                                            },
                                            icon: Icon(
                                              Icons.save,
                                              size: 20,
                                              color: Color.fromRGBO(
                                                  54, 112, 232, 1),
                                            ))
                                      ],
                                    ),
                                    _buildLicniPodaci(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Član od: ${formatDate(created)}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat',
                                              letterSpacing: 0.3,
                                              color:
                                                  Color.fromRGBO(60, 71, 92, 1),
                                            )))
                                  ],
                                ))
                          ],
                        ))),
                  ])));
  }

  _buildLicniPodaci() {
    return FormBuilder(
        key: _formKey,
        initialValue: {
          "ime": _korisnik.ime,
          "prezime": _korisnik.prezime,
          "email": _korisnik.email,
          "telefon": _korisnik.telefon,
          "adresa": _korisnik.adresa,
          "drzava": _korisnik.drzava
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FieldWithValidate(
              label: 'Ime:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "ime",
                decoration: newInput,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno'),
                ]),
              )),
          FieldWithValidate(
              label: 'Prezime:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "prezime",
                decoration: newInput,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno'),
                ]),
              )),
          FieldWithValidate(
              label: 'Email:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "email",
                decoration: newInput,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno'),
                  FormBuilderValidators.email(errorText: "Email nije validan")
                ]),
              )),
          FieldWithValidate(
              label: 'Telefon:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "telefon",
                decoration: newInput,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno'),
                  FormBuilderValidators.phoneNumber(
                      errorText: "Očekivani format: +38761000000",
                      regex: RegExp(r'^\+\d{11,12}$'))
                ]),
              )),
          FieldWithValidate(
              label: 'Adresa:',
              field: FormBuilderTextField(
                  style: TextStyle(fontSize: 14),
                  name: "adresa",
                  decoration: newInput,
                  validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Polje je obavezno')]))),
          _buildCountryInput(),
        ]));
  }

  _buildCountryInput() {
    return InkWell(
        child: IgnorePointer(
          child: FieldWithValidate(
              label: 'Država:',
              field: FormBuilderTextField(
                style: TextStyle(fontSize: 14),
                name: "drzava",
                decoration: newInput,
              )),
        ),
        onTap: () {
          showCountryPicker(
              context: context,
              onSelect: (Country country) {
                setState(() {
                  _formKey.currentState?.fields['drzava']
                      ?.didChange(country.name);
                });
              });
        });
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
}
