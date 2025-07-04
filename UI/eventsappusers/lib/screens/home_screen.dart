import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:eventsappusers/providers/kategorije_provider.dart';
import 'package:eventsappusers/providers/korisnik_provider.dart';
import 'package:eventsappusers/providers/recommender_provider.dart';
import 'package:eventsappusers/utils/category_color_util.dart';
import 'package:eventsappusers/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../widgets/dogadjaj_vertical.dart';
import '../widgets/heading_widget.dart';
import '../widgets/master_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  late KategorijeProvider _kategorijeProvider;
  late DogadjajProvider _dogadjajProvider;
  late RecommenderProvider _recommenderProvider;
  List<Dogadjaj>? _pratiteList;
  List<Dogadjaj>? _recommendedList;
  List<Dogadjaj>? _nearYouList;
  List<Dogadjaj>? _searchList;
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
    _dogadjajProvider = context.read<DogadjajProvider>();
    _kategorijeProvider = context.read<KategorijeProvider>();
    _recommenderProvider = context.read<RecommenderProvider>();
    loadKategorije();
    loadData();
  }

  Future<void> initializeCenter(String lokacija) async {
    LatLng latLong = await getLatLong(lokacija);
    setState(() {
      initialCenter = latLong;
      centerLoaded = true;
    });
    if (centerLoaded) loadNearYou();
  }

  void handleLoading() {
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

  Future<void> loadKategorije() async {
    var data = await _kategorijeProvider.get();
    CategoryColorManager(data.result);
    setState(() {
      kategorijeLoaded = true;
    });
    handleLoading();
  }

  Future<void> loadData() async {
    await _dogadjajProvider
        .getFollowing(KorisnikGlobal.korisnikId)
        .then((value) {
      setState(() {
        _pratiteList = value;
        pratiteLoaded = true;
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

    await _recommenderProvider
        .recommend(KorisnikGlobal.korisnikId ?? 0)
        .then((value) {
      setState(() {
        _recommendedList = value;
        recommendedLoaded = true;
      });
      handleLoading();
    });
  }

  Future<void> loadNearYou() async {
    var filterReq = {
      'Status': 'ACTIVE',
      'KategorijaIncluded': true,
      'Latitude': initialCenter?.latitude,
      'Longitude': initialCenter?.longitude,
      'OrderBy': '-created',
    };

    await _dogadjajProvider.get(filter: filterReq).then((value) {
      setState(() {
        _nearYouList = value.result;
        nearYouLoaded = true;
        handleLoading();
      });
    });
  }

  Future<void> search() async {
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
                ? SizedBox(
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
