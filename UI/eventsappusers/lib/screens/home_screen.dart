import 'package:eventsappusers/models/korisnik.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/providers/kategorije_provider.dart';
import 'package:eventsappusers/providers/korisnik_provider.dart';
import 'package:eventsappusers/utils/category_color_util.dart';
import 'package:eventsappusers/widgets/input_field.dart';
import 'package:flutter/material.dart';
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
  String searchController = "";
  bool isLoading = true;
  late KorisnikProvider _korisnikProvider;
  late KategorijeProvider _kategorijeProvider;

  _HomeScreenState();

  @override
  void initState() {
    super.initState();
    // _korisnikProvider = context.read<KorisnikProvider>();

    _kategorijeProvider = context.read<KategorijeProvider>();
    loadKategorije();
  }

  loadKategorije() async {
    var data = await _kategorijeProvider.get();
    CategoryColorManager(data.result);
    setState(() {
      isLoading = false;
    });
  }

  /* getKorisnik() async {
    /* await _korisnikProvider.getById();
    setState(() {
      _kategorijeList = kategorijeResult.result;
      isLoading = false;
    });*/
  }*/

  search() {
    print(searchController);
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
                      SizedBox(
                        height: 20,
                      ),
                      _buildDogadjajiTiles("Pratite"),
                      SizedBox(
                        height: 20,
                      ),
                      _buildDogadjajiTiles("Moglo bi Vam se svidjeti"),
                      SizedBox(
                        height: 20,
                      ),
                      _buildDogadjajiTiles("Najbliže Vama"),
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
                  controller: TextEditingController(text: searchController),
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

  Widget _buildDogadjajiTiles(String naslov) {
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
            Container(
              height: 240,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  children: [
                    DogadjajVerticalWidget(
                      naslov: "Test naslov dugi naslov",
                      datumOd: DateTime.now(),
                      datumDo: DateTime.now(),
                      kategorija: "Konferencije",
                      lokacija: "Spanija",
                    ),
                    DogadjajVerticalWidget(
                      naslov: "Test naslov",
                      datumOd: DateTime.now(),
                      datumDo: DateTime.now(),
                      kategorija: "Konferencije",
                      lokacija: "Spanija",
                    ),
                    DogadjajVerticalWidget(
                      naslov: "Test naslov",
                      datumOd: DateTime.now(),
                      datumDo: DateTime.now(),
                      kategorija: "Konferencije",
                      lokacija: "Spanija",
                    ),
                  ]),
            )
          ],
        ));
  }
}
