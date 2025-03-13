import 'dart:convert';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../widgets/dogadjaj_vertical.dart';
import '../widgets/full_screen_image.dart';
import '../widgets/master_screen.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String username = "hana123";
  Image _profilna = Image.asset('assets/images/banner.jpg', fit: BoxFit.cover);

  TextEditingController imeController = TextEditingController();
  TextEditingController prezimeController = TextEditingController();
  TextEditingController adresa1Controller = TextEditingController();
  TextEditingController adresa2Controller = TextEditingController();
  TextEditingController gradController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController postanskiBrojController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  TextEditingController drzavaController =
      TextEditingController(text: 'Bosnia');
  TextEditingController usernameController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController newPassConfirmController = TextEditingController();
  DateTime created = DateTime.now();
  bool _isExpanded = false;
  bool _locked = true;

  _EditProfileScreenState();

  Future getImage(Function(Image) onImageSelected) async {
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
      onImageSelected(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    return MasterScreen(
        selectedIndex: -1,
        showBackButton: true,
        showAppBar: true,
        child: Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
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
                                        tag: 'profilnaSlika', image: _profilna),
                                  ),
                                );
                              },
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(48), // Image radius
                                  child: _profilna,
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
                                    });
                                  });
                                }),
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _locked = false;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                  color: Color.fromRGBO(
                                                      54, 112, 232, 1),
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _locked = true;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.save,
                                                  size: 20,
                                                  color: Color.fromRGBO(
                                                      54, 112, 232, 1),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                    _buildLicniPodaci(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _promjenaSifre(),
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
    return Column(
      children: [
        InputWidget(
          controller: imeController,
          label: 'Ime:',
          readOnly: _locked,
        ),
        InputWidget(
          controller: prezimeController,
          label: 'Prezime:',
          readOnly: _locked,
        ),
        InputWidget(
          controller: emailController,
          label: 'Email:',
          readOnly: _locked,
        ),
        InputWidget(
          controller: usernameController,
          label: 'Korisničko ime:',
          readOnly: _locked,
        ),
        InputWidget(
          controller: telefonController,
          label: 'Telefon:',
          readOnly: _locked,
        ),
        InputWidget(
          controller: adresa1Controller,
          label: 'Adresa:',
          readOnly: _locked,
        ),
        InputWidget(
          controller: adresa2Controller,
          label: 'Adresa 2:',
          readOnly: _locked,
        ),
        InputWidget(
          controller: postanskiBrojController,
          label: 'Poštanski broj',
          readOnly: _locked,
        ),
        InputWidget(
          controller: gradController,
          label: 'Grad:',
          readOnly: _locked,
        ),
        _buildCountryInput()
      ],
    );
  }

  _buildCountryInput() {
    return InkWell(
        child: IgnorePointer(
            child: InputWidget(
          controller: drzavaController,
          label: 'Država',
          readOnly: _locked,
        )),
        onTap: () {
          if (_locked) return;
          showCountryPicker(
              context: context,
              onSelect: (Country country) {
                setState(() {
                  drzavaController.text = country.name;
                });
              });
        });
  }

  ExpansionPanelList _promjenaSifre() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Row(
              children: [
                Expanded(
                    child: ListTile(
                  title: Text(
                    'Promijeni šifru',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        letterSpacing: 0.3,
                        color: Color.fromRGBO(54, 112, 232, 1)),
                  ),
                )),
                if (_isExpanded)
                  IconButton(
                      onPressed: () {
                        //provjera jel sve popunjeno
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.save,
                        size: 20,
                        color: Color.fromRGBO(54, 112, 232, 1),
                      )),
              ],
            );
          },
          body: Column(
            children: [
              InputWidget(
                controller: oldPassController,
                label: 'Unesite trenutnu šifru:',
              ),
              InputWidget(
                controller: newPassController,
                label: 'Nova šifra:',
              ),
              InputWidget(
                controller: newPassConfirmController,
                label: 'Potvrdite novu šifru:',
              ),
            ],
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
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
