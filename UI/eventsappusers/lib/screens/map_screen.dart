import 'dart:ffi';

import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/kategorija.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:eventsappusers/providers/kategorije_provider.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:eventsappusers/utils/style_util.dart';
import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/master_screen.dart';

import 'package:latlong2/latlong.dart';
import 'package:latlong2/spline.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _datumOdDateController = TextEditingController();
  TextEditingController _datumDoDateController = TextEditingController();
  int? _kategorijaSelected;
  double latitude = 50;
  double longitude = 50;
  late LatLng? initialCenter;
  Key mapKey = UniqueKey();
  late KategorijeProvider _kategorijeProvider;
  late List<Kategorija> _kategorijeList;
  bool isLoading = true;
  bool kategorijaLoaded = false;
  bool mapLoaded = false;
  DateTime? _datumOd;
  DateTime? _datumDo;
  String defaultLokacija = KorisnikGlobal.lokacija ?? 'Sarajevo';
  late DogadjajProvider _dogadjajProvider;
  late List<Dogadjaj>? _dogadjajiResult;
  _MapScreenState();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _kategorijeProvider = context.read<KategorijeProvider>();
    _dogadjajProvider = context.read<DogadjajProvider>();
    loadData();
    _search(defaultLokacija);
  }

  handleLoading() {
    print("pozvan handle loading");
    print("kategorija $kategorijaLoaded mapa $mapLoaded");
    if (kategorijaLoaded == true && mapLoaded == true) {
      setState(() {
        isLoading = false;
      });
    }
  }

  loadData() async {
    _kategorijeProvider.get().then((value) {
      setState(() {
        _kategorijeList = value.result;
        // initialCenter = extractLatitudeLongitude(lokacija ?? 'Sarajevo');
        kategorijaLoaded = true;
      });
      handleLoading();
    });
  }

  extractLatitudeLongitude(String output) {
    print("lokacija $output");
    String latitudeKey = 'Latitude: ';
    String longitudeKey = 'Longitude: ';

    int latitudeStartIndex = output.indexOf(latitudeKey) + latitudeKey.length;
    int longitudeStartIndex =
        output.indexOf(longitudeKey) + longitudeKey.length;

    int latitudeEndIndex = output.indexOf(',', latitudeStartIndex);
    int longitudeEndIndex = output.indexOf(',', longitudeStartIndex);

    String lat = output.substring(latitudeStartIndex, latitudeEndIndex).trim();
    String long =
        output.substring(longitudeStartIndex, longitudeEndIndex).trim();

    return LatLng(double.parse(lat), double.parse(long));
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
            ? {
                _datumOd = picked,
                _datumOdDateController.text = formatDate(picked)
              }
            : {
                _datumDo =
                    DateTime(picked.year, picked.month, picked.day, 23, 59, 59),
                _datumDoDateController.text = formatDate(picked)
              };
      });
    }
  }

  String printDate(DateTime date) {
    return date.day.toString() +
        ". " +
        date.month.toString() +
        ". " +
        date.year.toString() +
        ".";
  }

  handleException(String msg) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exception'),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              handleLoading();
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  showFilterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Filtriranje"),
              content: SingleChildScrollView(
                  child: Column(
                children: [
                  InputWidget(
                      label: "Lokacija:",
                      controller: _cityController,
                      placeholder: "Lokacija"),
                  if (!isLoading) _buildKategorija(),
                  _buildDatePicker(),
                ],
              )),
              actions: [
                TextButton(
                    onPressed: () {
                      filter();
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            ));
  }

  _search(String lokacija) async {
    try {
      await locationFromAddress(lokacija).then((locations) {
        print("dobili smo neku lokaciju");
        var output = 'No results found.';
        if (locations.isNotEmpty) {
          output = locations[0].toString();
          _refreshMap(output);
        }
      });
    } on Exception catch (e) {
      if (lokacija == defaultLokacija)
        handleException(
            "Nije moguće pronaći vašu lokaciju. \n U postavkama profila unesite validnu adresu.");
      else
        handleException(
            "Nije moguće pronaći traženu lokaciju, unesite validnu adresu");
      setState(() {
        initialCenter = null;
        mapLoaded = true;
      });
    }
  }

  filter() {
    //TBD
    var filterReq = {
      'FTS': _searchController.text,
      'Lokacija': _cityController.text,
      'Kategorija': _kategorijaSelected,
      'DatumOd': _datumOd,
      'DatumDo': _datumDo
    };
    print("filtriranje ${filterReq}");
    try {
      _dogadjajProvider.get(filter: filterReq).then((value) {
        setState(() {
          _dogadjajiResult = value.result;
        });
        print("dogadjaji result $_dogadjajiResult");
      });
    } on Exception catch (e) {
      handleException(e.toString());
    }
  }

  _refreshMap(String output) {
    LatLng newCenter = extractLatitudeLongitude(output);
    setState(() {
      mapKey = UniqueKey();
      initialCenter = newCenter;
      mapLoaded = true;
    });
    handleLoading();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        selectedIndex: 1,
        showBackButton: true,
        child: Expanded(
            child: isLoading
                ? Container(
                    child: Center(child: const CircularProgressIndicator()))
                : Stack(
                    children: [
                      Column(
                        children: [
                          _buildSearch(),
                          SizedBox(
                            height: 15,
                          ),
                          _buildMap(initialCenter),
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        right: 5,
                        child: FloatingActionButton(
                          onPressed: () {
                            showFilterDialog();
                          },
                          child: const Icon(Icons.tune),
                        ),
                      )
                    ],
                  )));
  }

  _buildSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(4, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _searchController,
                  decoration:
                      new InputDecoration.collapsed(hintText: 'Naziv događaja'),
                ),
              )),
              Container(
                  child: IconButton(
                onPressed: () {
                  _search(_cityController.text);
                },
                icon: const Icon(Icons.search),
                iconSize: 25,
                color: Colors.black,
                splashRadius: 10,
              ))
            ],
          )),
    );
  }

  _buildMap(initialCenter) {
    print('initialCenter: $initialCenter,');
    if (initialCenter == null)
      return Text("Greška prilikom učitavanja lokacije");
    return Expanded(
        child: Stack(children: [
      FlutterMap(
          key: mapKey,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 18.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(
              markers: [
                Marker(
                    key: Key('you'),
                    point: initialCenter,
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.pin_drop,
                      size: 40,
                      color: Color.fromRGBO(232, 66, 54, 1),
                    )),
              ],
            ),
          ]),
      /*Positioned(
        top: 10,
        right: 10,
        child: FloatingActionButton(
          onPressed: _refreshMap,
          child: Icon(Icons.refresh),
        ),
      ),*/
    ]));
  }

  _buildKategorija() {
    return Column(children: [
      SizedBox(height: 5),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                textAlign: TextAlign.left,
                "Kategorija:",
                style: TextStyle(
                    color: Color.fromRGBO(60, 71, 92, 1),
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    letterSpacing: 0.3),
              ))),
      FormField<int>(
        builder: (FormFieldState<int> state) {
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
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
                              EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 164, 163, 163),
                              fontSize: 11.0),
                          hintText: 'Kategorija',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20.0))),
                      isEmpty: _kategorijaSelected == null,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                          value: _kategorijaSelected,
                          isDense: true,
                          onChanged: (int? newValue) {
                            setState(() {
                              _kategorijaSelected =
                                  newValue ?? _kategorijaSelected;
                              state.didChange(newValue);
                            });
                          },
                          items: _kategorijeList.map((Kategorija value) {
                            return DropdownMenuItem<int>(
                              value: value.kategorijaId,
                              child: Text(
                                value.naziv ?? '',
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 88, 87, 87)),
                              ),
                            );
                          }).toList(),
                        ),
                      ))));
        },
      )
    ]);
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
                        controller: _datumOdDateController,
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
                            label: 'Do:',
                            controller: _datumDoDateController)))),
          ])
        ]));
  }
}
