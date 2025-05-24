import 'dart:ffi';

import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/models/narudzba.dart';
import 'package:eventsappusers/screens/narudzba_preview_screen.dart';
import 'package:eventsappusers/utils/style_util.dart';
import 'package:eventsappusers/widgets/field_with_validate.dart';
import 'package:eventsappusers/widgets/input_form_field.dart';
import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../widgets/master_screen.dart';
import '../widgets/narudzba_master_screen.dart';
import 'package:country_picker/country_picker.dart';

class PersonalInfoScreen extends StatefulWidget {
  Narudzba narudzba;
  Dogadjaj dogadjaj;
  PersonalInfoScreen(
      {super.key, required this.narudzba, required this.dogadjaj});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  double _contentHeight = 0;
  String? locationImage = "assets/images/banner.jpg";
  final _infoFormKey = new GlobalKey<FormBuilderState>();
  var _preuzimanjeList = ["Poštom", "E-karta"];
  _PersonalInfoScreenState();

  clickNextStep() {
    bool formValid = _infoFormKey.currentState?.saveAndValidate() ?? false;
    if (formValid) {
      Narudzba n = widget.narudzba;
      n.ime = _infoFormKey.currentState?.value["Ime"];
      n.prezime = _infoFormKey.currentState?.value["Prezime"];
      n.adresa = _infoFormKey.currentState?.value["Adresa"];
      n.postanskiBroj =
          int.parse(_infoFormKey.currentState?.value["PostanskiBroj"]);
      n.grad = _infoFormKey.currentState?.value["Grad"];
      n.drzava = _infoFormKey.currentState?.value["Drzava"];
      n.email = _infoFormKey.currentState?.value["Email"];
      n.telefon = _infoFormKey.currentState?.value["Telefon"];
      n.tip = _infoFormKey.currentState?.value["PreuzimanjeKarata"];
      n.korisnikId = KorisnikGlobal.korisnikId;

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              //PaymentInfoScreen(narudzba: n, dogadjaj: widget.dogadjaj)
              NarudzbaPreviewScreen(narudzba: n, dogadjaj: widget.dogadjaj)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        selectedIndex: -1,
        showBackButton: true,
        showAppBar: true,
        child: Expanded(
            child: NarudzbaMasterScreen(
                naslov: "Narudžba",
                childHeight: _contentHeight,
                tabActive: 1,
                onClickNext: clickNextStep,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _contentHeight = context.size!.height;
                      });
                    }
                  });
                  return Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 191, 190, 190),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(4, 5),
                              ),
                            ]),
                        child: FormBuilder(
                            key: _infoFormKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //radi overflowa na validaciji
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildHeading("Lični podaci"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FieldWithValidate(
                                      label: 'Ime:',
                                      field: FormBuilderTextField(
                                        style: TextStyle(fontSize: 14),
                                        name: "Ime",
                                        decoration: inputField,
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              errorText: "Polje je obavezno"),
                                        ]),
                                      )),
                                  SizedBox(height: 5),
                                  FieldWithValidate(
                                      label: 'Prezime:',
                                      field: FormBuilderTextField(
                                        style: TextStyle(fontSize: 14),
                                        name: "Prezime",
                                        decoration: inputField,
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              errorText: "Polje je obavezno"),
                                        ]),
                                      )),
                                  SizedBox(height: 5),
                                  FieldWithValidate(
                                      label: 'Adresa:',
                                      field: FormBuilderTextField(
                                        style: TextStyle(fontSize: 14),
                                        name: "Adresa",
                                        decoration: inputField,
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              errorText: "Polje je obavezno"),
                                        ]),
                                      )),
                                  SizedBox(height: 5),
                                  FieldWithValidate(
                                      label: 'Poštanski broj:',
                                      field: FormBuilderTextField(
                                        style: TextStyle(fontSize: 14),
                                        name: "PostanskiBroj",
                                        decoration: inputField,
                                        keyboardType: TextInputType.number,
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              errorText: "Polje je obavezno"),
                                          FormBuilderValidators.numeric(
                                              errorText:
                                                  "Dozvoljeni su samo brojevi")
                                        ]),
                                      )),
                                  SizedBox(height: 5),
                                  FieldWithValidate(
                                      label: 'Grad:',
                                      field: FormBuilderTextField(
                                        style: TextStyle(fontSize: 14),
                                        name: "Grad",
                                        decoration: inputField,
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              errorText: "Polje je obavezno"),
                                        ]),
                                      )),
                                  SizedBox(height: 5),
                                  _buildCountryInput(),
                                  SizedBox(height: 5),
                                  FieldWithValidate(
                                      label: 'Email:',
                                      field: FormBuilderTextField(
                                        style: TextStyle(fontSize: 14),
                                        name: "Email",
                                        decoration: inputField,
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              errorText: "Polje je obavezno"),
                                          FormBuilderValidators.email(
                                              errorText: "Neispravan email")
                                        ]),
                                      )),
                                  SizedBox(height: 5),
                                  FieldWithValidate(
                                      label: 'Broj telefona:',
                                      field: FormBuilderTextField(
                                        style: TextStyle(fontSize: 14),
                                        name: "Telefon",
                                        decoration: inputField,
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              errorText: "Polje je obavezno"),
                                          FormBuilderValidators.phoneNumber(
                                              errorText:
                                                  "Očekivani format: +38761000000",
                                              regex: RegExp(r'^\+\d{11,12}$'))
                                        ]),
                                      )),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  _buildDropdownList(),
                                ])),
                      ));
                }))));
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

  _buildDropdownList() {
    return FieldWithValidate(
        label: 'Odaberite način preuzimanja karata:',
        field: FormBuilderDropdown(
            name: 'PreuzimanjeKarata',
            decoration: inputField,
            items: _preuzimanjeList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style:
                      TextStyle(color: const Color.fromARGB(255, 88, 87, 87)),
                ),
              );
            }).toList(),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'Polje je obavezno')
            ]),
            onChanged: (String? newValue) {
              setState(() {
                FormBuilder.of(context)
                    ?.fields['PreuzimanjeKarata']
                    ?.didChange(newValue);
              });
            }));
  }

  _buildCountryInput() {
    return InkWell(
        child: IgnorePointer(
            child: FieldWithValidate(
                label: 'Država:',
                field: FormBuilderTextField(
                  style: TextStyle(fontSize: 14),
                  name: "Drzava",
                  decoration: inputField,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Polje je obavezno"),
                  ]),
                ))),
        onTap: () {
          showCountryPicker(
              context: context,
              onSelect: (Country country) {
                print(FormBuilder.of(context)?.fields["Drzava"]?.value);
                setState(() {
                  _infoFormKey.currentState
                      ?.patchValue({"Drzava": country.name});
                  _infoFormKey.currentState?.save();
                  print(_infoFormKey.currentState?.value["Drzava"]);
                });
              });
        });
  }
}
