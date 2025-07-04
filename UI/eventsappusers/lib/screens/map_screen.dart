import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/kategorija.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:eventsappusers/providers/kategorije_provider.dart';
import 'package:eventsappusers/utils/category_color_util.dart';
import 'package:eventsappusers/widgets/dogadjaj_vertical.dart';
import 'package:eventsappusers/widgets/events_map_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/master_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  DateTime? _datumOd = DateTime.now();
  DateTime? _datumDo = DateTime.now().add(Duration(days: 100));
  late TextEditingController _datumOdController;
  late TextEditingController _datumDoController;
  int? _kategorijaSelected;
  late LatLng? initialCenter;
  Key mapKey = UniqueKey();
  late KategorijeProvider _kategorijeProvider;
  late List<Kategorija> _kategorijeList;
  bool isLoading = true;
  bool kategorijaLoaded = false;
  bool mapLoaded = false;
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
    _datumOdController = TextEditingController(
        text: _datumOd == null
            ? ""
            : "${_datumOd?.day}.${_datumOd?.month}.${_datumOd?.year}.");
    _datumDoController = TextEditingController(
        text: _datumDo == null
            ? ""
            : "${_datumDo?.day}.${_datumDo?.month}.${_datumDo?.year}.");
    loadKategorije();
    getLatLong(defaultLokacija);
  }

  void handleLoading() {
    if (kategorijaLoaded == true && mapLoaded == true) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadKategorije() async {
    _kategorijeProvider.get().then((value) {
      setState(() {
        _kategorijeList = value.result;
        kategorijaLoaded = true;
      });
      handleLoading();
    });
  }

  LatLng extractLatitudeLongitude(Location location) {
    double lat = location.latitude;
    double long = location.longitude;
    return LatLng(lat, long);
  }

  String printDate(DateTime date) {
    return "${date.day}. ${date.month}. ${date.year}.";
  }

  void handleException(String msg) {
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
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showFilterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => EventsMapFilter(
              searchController: _searchController,
              onFilterTap: filter,
              kategorijaSelected: _kategorijaSelected,
              kategorijeList: _kategorijeList,
              onKategorijaSelected: (int? selected) {
                setState(() {
                  _kategorijaSelected = selected;
                });
              },
              datumOd: _datumOd,
              datumDo: _datumDo,
              datumOdController: _datumOdController,
              datumDoController: _datumDoController,
              onDateSelected: (DateTime? value, String caller) {
                if (caller == "_datumOd") {
                  setState(() {
                    _datumOd = value;
                  });
                } else {
                  setState(() {
                    _datumDo = value;
                  });
                }
              },
            ));
  }

  Future<void> getLatLong(String lokacija) async {
    try {
      var locations = await locationFromAddress(lokacija);
      if (locations.isNotEmpty) {
        _refreshMap(locations[0]);
      }
    } on Exception {
      handleException(
          "Nije moguće pronaći traženu lokaciju, unesite validnu adresu");
      setState(() {
        initialCenter = null;
        mapLoaded = true;
      });
    }
  }

  void cityChanged() {
    if (_cityController.text.isNotEmpty) {
      getLatLong(_cityController.text);
    }
  }

  Future<void> filter() async {
    setState(() {
      isLoading = true;
    });

    var filterReq = {
      'FTS': _searchController.text,
      'Kategorija': _kategorijaSelected,
      'DatumOd': _datumOd,
      'DatumDo': _datumDo,
      'Status': 'ACTIVE',
      'Latitude': initialCenter?.latitude,
      'Longitude': initialCenter?.longitude,
      'KategorijaIncluded': true
    };

    try {
      var value = await _dogadjajProvider.get(filter: filterReq);
      setState(() {
        _dogadjajiResult = value.result;
        mapLoaded = true;
        handleLoading();
      });
    } on Exception catch (e) {
      handleException(e.toString());
    }
  }

  void _showEventDetails(Dogadjaj event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Center(child: DogadjajVerticalWidget(dogadjaj: event)),
        );
      },
    );
  }

  void _refreshMap(Location location) {
    LatLng newCenter = extractLatitudeLongitude(location);
    setState(() {
      mapKey = UniqueKey();
      initialCenter = newCenter;
    });
    filter();
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
                          if (isLoading == false) _buildMap(initialCenter),
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

  Padding _buildSearch() {
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
                  controller: _cityController,
                  decoration:
                      InputDecoration.collapsed(hintText: 'Naziv grada'),
                ),
              )),
              Container(
                  child: IconButton(
                onPressed: () {
                  cityChanged();
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

  Widget _buildMap(initialCenter) {
    if (initialCenter == null) {
      return Text("Greška prilikom učitavanja lokacije");
    }

    List<Marker> eventMarkers = [];

    if (_searchController.text != '') {
      if (_dogadjajiResult == null || _dogadjajiResult!.isEmpty) {
        return Text("Događaj nije pronađen");
      }
      Dogadjaj? first = _dogadjajiResult?.first;
      setState(() {
        initialCenter = LatLng(first?.latitude ?? 0, first?.longitude ?? 0);
      });

      eventMarkers.add(
        Marker(
          key: Key(first!.dogadjajId.toString()),
          point: LatLng(first.latitude ?? 0, first.longitude ?? 0),
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              _showEventDetails(first);
            },
            child: Icon(
              Icons.location_on,
              size: 40,
              color: CategoryColorManager()
                  .getColorForCategory(first.kategorija?.kategorijaId ?? 0),
            ),
          ),
        ),
      );
    } else {
      eventMarkers = _dogadjajiResult?.map((event) {
            return Marker(
              key: Key(event.dogadjajId.toString()),
              point: LatLng(event.latitude ?? 0, event.longitude ?? 0),
              width: 60,
              height: 60,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  _showEventDetails(event);
                },
                child: Icon(
                  Icons.location_on,
                  size: 40,
                  color: CategoryColorManager()
                      .getColorForCategory(event.kategorija?.kategorijaId ?? 0),
                ),
              ),
            );
          }).toList() ??
          [];

      eventMarkers.add(
        Marker(
          key: Key('you'),
          point: initialCenter,
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: Icon(
            Icons.pin_drop,
            size: 40,
            color: const Color.fromARGB(255, 255, 93, 68),
          ),
        ),
      );
    }

    return Expanded(
        child: Stack(children: [
      FlutterMap(
          key: mapKey,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 15.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(markers: eventMarkers),
          ]),
    ]));
  }
}
