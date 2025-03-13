import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/master_screen.dart';
import '../widgets/narudzba_master_screen.dart';
import 'package:country_picker/country_picker.dart';

class PersonalInfoScreen extends StatefulWidget {
  PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  double _contentHeight = 0;
  String? locationImage = "assets/images/banner.jpg";
  //String? locationImage = null;
  List? karteList = [
    {'nazivKarte': 'Zona B', 'raspolozivo': 5, 'cijena': 15},
    {'nazivKarte': 'Zona A', 'raspolozivo': 10, 'cijena': 30}
  ];

  TextEditingController imeController = TextEditingController();
  TextEditingController prezimeController = TextEditingController();
  TextEditingController adresa1Controller = TextEditingController();
  TextEditingController adresa2Controller = TextEditingController();
  TextEditingController gradController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController postanskiBrojController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  TextEditingController drzavaController = TextEditingController();

  String _currentSelectedValue = 'Poštom';
  String _countrySelectedValue = '-';
  var _preuzimanjeList = ["Poštom", "E-karta"];
  var _drzaveList = ["-"];
  _PersonalInfoScreenState();

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
                : NarudzbaMasterScreen(
                    naslov: "Narudžba",
                    childHeight: _contentHeight,
                    tabActive: 1,
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
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildHeading("Lični podaci"),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InputWidget(
                                      controller: imeController,
                                      placeholder: "Ime"),
                                  InputWidget(
                                      controller: prezimeController,
                                      placeholder: "Prezime"),
                                  InputWidget(
                                      controller: adresa1Controller,
                                      placeholder: "Adresa"),
                                  InputWidget(
                                      controller: adresa2Controller,
                                      placeholder: "Adresa 2"),
                                  InputWidget(
                                    controller: postanskiBrojController,
                                    placeholder: "Poštanski broj",
                                    type: 'number',
                                  ),
                                  InputWidget(
                                      controller: gradController,
                                      placeholder: "Grad"),
                                  _buildCountryInput(),
                                  InputWidget(
                                      controller: emailController,
                                      placeholder: "Email"),
                                  InputWidget(
                                      controller: telefonController,
                                      placeholder: "Broj telefona",
                                      type: 'number'),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Odaberite način preuzimanja karata: ",
                                    style: TextStyle(
                                        color: Color.fromRGBO(60, 71, 92, 1),
                                        letterSpacing: 0.3,
                                        fontFamily: 'Montserrat',
                                        fontSize: 15),
                                  ),
                                  _buildDropdownList(),
                                ]),
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
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Container(
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
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 11.0),
                        hintText: 'Način preuzimanja karata',
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0))),
                    isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        value: _currentSelectedValue,
                        isDense: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _currentSelectedValue = newValue ?? 'Poštom';
                            state.didChange(newValue);
                          });
                        },
                        items: _preuzimanjeList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 88, 87, 87)),
                            ),
                          );
                        }).toList(),
                      ),
                    ))));
      },
    );
  }

  _buildCountryInput() {
    return InkWell(
        child: IgnorePointer(
            child: InputWidget(
          controller: drzavaController,
          placeholder: "Država",
        )),
        onTap: () {
          showCountryPicker(
              context: context,
              onSelect: (Country country) {
                setState(() {
                  drzavaController.text = country.name;
                });
              });
        });
  }

  /* _buildCountryDropdownList() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Container(
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
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 11.0),
                        hintText: 'Država',
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0))),
                    isEmpty: _countrySelectedValue == '-',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        value: _countrySelectedValue,
                        isDense: true,
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            onSelect: (Country country) {
                              print('Select country: ${country.name}');
                              setState(() {
                                _drzaveList.add(country.name);
                                _countrySelectedValue = country.name ?? '-';
                              });
                            },
                          );
                        },
                        onChanged: (String? newValue) {
                          /*  setState(() {
                            _countrySelectedValue = _selectedCountry ?? '-';
                            state.didChange(_selectedCountry);
                          });*/
                          print("on change called");
                        },
                        items: _drzaveList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 88, 87, 87)),
                            ),
                          );
                        }).toList(),
                      ),
                    ))));
      },
    );
  }*/

  /* _buildInput(
      TextEditingController controller, String placeholder, String? type) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Container(
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
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                    controller: controller,
                    keyboardType:
                        type == "number" ? TextInputType.number : null,
                    decoration: new InputDecoration.collapsed(
                      hintText: placeholder,
                    )),
              )),
              /* Container(
                  child: IconButton(
                onPressed: () {
                  //   search();
                },
                icon: const Icon(Icons.search),
                iconSize: 25,
                color: Colors.black,
                splashRadius: 10,
              ))*/
            ],
          )),
    );
  }*/
}
