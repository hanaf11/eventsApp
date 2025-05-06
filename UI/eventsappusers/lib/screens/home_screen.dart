import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/korisnik.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:eventsappusers/providers/kategorije_provider.dart';
import 'package:eventsappusers/providers/korisnik_provider.dart';
import 'package:eventsappusers/utils/category_color_util.dart';
import 'package:eventsappusers/utils/util.dart';
import 'package:eventsappusers/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../widgets/dogadjaj_horizontal.dart';
import '../widgets/dogadjaj_vertical.dart';
import '../widgets/heading_widget.dart';
import '../widgets/master_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = new TextEditingController();
  bool isLoading = true;
  late KorisnikProvider _korisnikProvider;
  late KategorijeProvider _kategorijeProvider;
  late DogadjajProvider _dogadjajProvider;
  List<Dogadjaj>? _pratiteList;
  List<Dogadjaj>? _recommendedList;
  List<Dogadjaj>? _nearYouList;
  List<Dogadjaj>? _searchList = null;
  List<Dogadjaj>? _newList;
  bool pratiteLoaded = false;
  bool recommendedLoaded = false;
  bool nearYouLoaded = false;
  bool kategorijeLoaded = false;
  bool newLoaded = false;
  bool searchLoaded = false;
  bool centerLoaded = false;
  late LatLng? initialCenter;
  String defaultLokacija = KorisnikGlobal.lokacija ?? 'Sarajevo';

  _HomeScreenState();

  @override
  void initState() {
    super.initState();
    initializeCenter(defaultLokacija);
    _korisnikProvider = context.read<KorisnikProvider>();
    _dogadjajProvider = context.read<DogadjajProvider>();
    _kategorijeProvider = context.read<KategorijeProvider>();
    loadKategorije();
    loadData();
  }

  initializeCenter(String lokacija) async {
    print("lokacija $lokacija");
    /*ry {
      var locations = await locationFromAddress(lokacija);
      if (locations.isNotEmpty) {
        double lat = locations[0].latitude;
        double long = locations[0].latitude;
        print(lat);
        print(long);
        var latLong = LatLng(lat, long);
        setState(() {
          initialCenter = latLong;
          centerLoaded = true;
        });
      } else {
        setState(() {
          initialCenter = LatLng(0, 0);
          centerLoaded = true;
        });
      }
    } on Exception catch (e) {
      print("Nije moguće pronaći traženu lokaciju, unesite validnu adresu");
      return const LatLng(0, 0);
    }*/
    LatLng latLong = await getLatLong(lokacija);
    setState(() {
      initialCenter = latLong;
      centerLoaded = true;
    });
    if (centerLoaded) loadNearYou();
  }

  handleLoading() {
    if (pratiteLoaded == true &&
        nearYouLoaded == true &&
        recommendedLoaded == true &&
        kategorijeLoaded == true &&
        newLoaded == true) {
      setState(() {
        isLoading = false;
      });
    }
  }

  loadKategorije() async {
    var data = await _kategorijeProvider.get();
    CategoryColorManager(data.result);
    setState(() {
      kategorijeLoaded = true;
    });
    handleLoading();
  }

  loadData() async {
    await _dogadjajProvider
        .getFollowing(KorisnikGlobal.korisnikId)
        .then((value) {
      print("result je $value");
      setState(() {
        _pratiteList = value;
        pratiteLoaded = true;
        recommendedLoaded = true;
      });
      handleLoading();
    });

    var filterReq = {
      'Status': 'ACTIVE',
      'KategorijaIncluded': true,
      'OrderBy': '-created'
    };
    await _dogadjajProvider.get(filter: filterReq).then((value) {
      setState(() {
        _newList = value.result;
        newLoaded = true;
      });
      handleLoading();
    });
  }

  loadNearYou() async {
    var filterReq = {
      'Status': 'ACTIVE',
      'KategorijaIncluded': true,
      'Latitude': initialCenter?.latitude,
      'Longitude': initialCenter?.longitude,
      'OrderBy': '-created',
    };
    await _dogadjajProvider.get(filter: filterReq).then((value) {
      print("dogadjaji: $value");
      setState(() {
        _nearYouList = value.result;
        nearYouLoaded = true;
      });
      handleLoading();
    });
  }

  /* getKorisnik() async {
    /* await _korisnikProvider.getById();
    setState(() {
      _kategorijeList = kategorijeResult.result;
      isLoading = false;
    });*/
  }*/

  search() async {
    var filterReq = {
      'FTS': _searchController.text,
      'Status': 'ACTIVE',
      'KategorijaIncluded': true,
      'OrderBy': '-created'
    };
    var data = await _dogadjajProvider.get(filter: filterReq);
    setState(() {
      _searchList = data.result;
      searchLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        selectedIndex: 0,
        showBackButton: false,
        showFollowButton: false,
        child: Expanded(
            child: isLoading
                ? Container(
                    child: Center(child: const CircularProgressIndicator()))
                : ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: HeadingWidget(
                                  text: "Dobar dan, ${KorisnikGlobal.ime}"))),
                      SizedBox(
                        height: 15,
                      ),
                      _buildSearch(),
                      if (searchLoaded)
                        _buildDogadjajiTiles("Pretraga", _searchList),
                      SizedBox(
                        height: 20,
                      ),
                      _buildDogadjajiTiles("Najnovije", _newList),
                      SizedBox(
                        height: 20,
                      ),
                      _buildDogadjajiTiles("Pratite", _pratiteList),
                      SizedBox(
                        height: 20,
                      ),
                      _buildDogadjajiTiles(
                          "Moglo bi Vam se svidjeti", _recommendedList),
                      SizedBox(
                        height: 20,
                      ),
                      _buildDogadjajiTiles("Najbliže Vama", _nearYouList),
                      SizedBox(
                        height: 20,
                      ),
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
                  decoration: null,
                ),
              )),
              Container(
                  child: IconButton(
                onPressed: () {
                  search();
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

  Widget _buildDogadjajiTiles(String naslov, List<Dogadjaj>? dogadjajiList) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(54, 112, 232, 1),
                    letterSpacing: 0.4,
                    fontSize: 24),
                naslov),
            SizedBox(height: 10),
            (dogadjajiList != null && dogadjajiList.isNotEmpty)
                ? Container(
                    height: 240,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(5),
                        itemCount: dogadjajiList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Dogadjaj d = dogadjajiList[index];
                          return DogadjajVerticalWidget(dogadjaj: d);
                        }),
                  )
                : Container(
                    child: Text("Nema rezultata"),
                  )
          ],
        ));
  }
}
