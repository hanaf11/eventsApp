import 'dart:convert';
import 'dart:io';

import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:eventsappusers/widgets/list_input_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

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

  List<String> kategorije = ['Festivali', 'Koncerti', 'Predstave', 'Trke', '-'];
  final formKey = new GlobalKey<FormState>();
  List? _myActivities = [];
  String _kategorijaSelected = "-";
  late String _myActivitiesResult = '';
  TimeOfDay timeOfDay = TimeOfDay.now();
  //Image _naslovna = Image.asset('assets/images/empty.jpg', fit: BoxFit.cover);
  Image? _naslovna;
  Image? _program;
  /*final List<String> imageList = [
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',

    // Add more image paths
  ];*/
  final List<Image> imageList = [];

  _saveForm() {
    var form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivitiesResult = _myActivities.toString();
      });
    }
  }

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

  _KreirajDogadjajScreenState();

  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    return MasterScreen(
        selectedIndex: 3,
        showBackButton: true,
        showAppBar: true,
        child: Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : NarudzbaMasterScreen(
                    naslov: "Kreiraj događaj",
                    childHeight: _contentHeight,
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
                                  InputWidget(
                                    controller: nazivController,
                                    label: 'Naziv',
                                  ),
                                  _buildDatePicker(),
                                  InputWidget(
                                      controller: lokacijaController,
                                      label: 'Lokacija'),
                                  ListInputWidget(
                                    valueList: kategorije,
                                    label: 'Odaberite kategoriju:',
                                  ),
                                  _buildMultipleChoice(),
                                  InputWidget(
                                      controller: websiteController,
                                      label: 'Website'),
                                  InputWidget(
                                    controller: opisController,
                                    label: 'Opis',
                                    type: 'multiline',
                                  ),
                                  InputWidget(
                                      controller: programController,
                                      label: 'Program',
                                      type: 'multiline'),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Program slika:',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      60, 71, 92, 1),
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 15,
                                                  letterSpacing: 0.3),
                                            ),
                                            _dodajSliku((image) {
                                              setState(() {
                                                _program = image;
                                              });
                                            }),
                                          ])),
                                  _buildImage(_program, 'programSlika'),
                                  SizedBox(height: 15),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Naslovna slika:',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    60, 71, 92, 1),
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                letterSpacing: 0.3),
                                          ),
                                          _dodajSliku((image) {
                                            setState(() {
                                              _naslovna = image;
                                            });
                                          }),
                                        ],
                                      )),
                                  _buildImage(_naslovna, 'naslovnaSlika'),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Galerija:',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    60, 71, 92, 1),
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                letterSpacing: 0.3),
                                          ),
                                          _dodajSliku((image) {
                                            setState(() {
                                              imageList.add(image);
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
                                  SizedBox(height: 20),
                                  Center(
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Objavi",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat'),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 100,
                                                  vertical: 10),
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                              textStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ))))
                                ]),
                          ));
                    }))));
  }

  _dodajSliku(Function(Image) onImageSelected) {
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
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: InkWell(
                      onTap: () {
                        _selectDate(context, 'datumOd');
                      },
                      child: IgnorePointer(
                          child: InputWidget(
                        label: 'Od:',
                        controller: datumOdDateController,
                      )))),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        _selectTime(context, 'datumOd');
                      },
                      child: IgnorePointer(
                          child: InputWidget(
                        controller: datumOdTimeController,
                      )))),
            ],
          ),
          Row(children: [
            Expanded(
                child: InkWell(
                    onTap: () {
                      _selectDate(context, 'datumDo');
                    },
                    child: IgnorePointer(
                        child: InputWidget(
                            label: 'Do:', controller: datumDoDateController)))),
            Expanded(
                child: InkWell(
                    onTap: () {
                      _selectTime(context, 'datumDo');
                    },
                    child: IgnorePointer(
                        child: InputWidget(
                      controller: datumDoTimeController,
                    )))),
          ])
        ]));
  }

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
  }

  _buildMultipleChoice() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(0),
            child: MultiSelectFormField(
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
                if (value == null || value.length == 0) {
                  return 'Please select one or more options';
                }
                return null;
              },
              dataSource: [
                {
                  "display": "Running",
                  "value": "Running",
                },
                {
                  "display": "Climbing",
                  "value": "Climbing",
                },
                {
                  "display": "Walking",
                  "value": "Walking",
                },
                {
                  "display": "Swimming",
                  "value": "Swimming",
                },
                {
                  "display": "Soccer Practice",
                  "value": "Soccer Practice",
                },
                {
                  "display": "Baseball Practice",
                  "value": "Baseball Practice",
                },
                {
                  "display": "Football Practice",
                  "value": "Football Practice",
                },
              ],
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
              initialValue: _myActivities,
              onSaved: (value) {
                if (value == null) return;
                setState(() {
                  _myActivities = value;
                });
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
}
