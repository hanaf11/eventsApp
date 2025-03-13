import 'package:eventsappusers/main.dart';
import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:eventsappusers/screens/edit_profile_screen.dart';
import 'package:eventsappusers/screens/kreiraj_dogadjaj_screen.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/dogadjaj_vertical.dart';
import '../widgets/master_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = KorisnikGlobal.username ?? 'username';
  Image _profilna = imageFromBase64String(KorisnikGlobal.slika);
  String _lokacija = KorisnikGlobal.lokacija ?? '';
  bool _isLoading = true;
  bool _kupovinaLoaded = false;
  bool _pregledanoLoaded = false;
  bool _kreiranoLoaded = false;
  List<Dogadjaj>? _kreiranoList;
  List<Dogadjaj>? _pregledanoList;
  List<Dogadjaj>? _kupljenoList;
  late DogadjajProvider _dogadjajProvider;

  _ProfileScreenState();

  @override
  void initState() {
    super.initState();
    _dogadjajProvider = context.read<DogadjajProvider>();
    loadKupljeno();
    loadHistorijaPregleda();
    loadKreirano();
  }

  loadKreirano() async {
    var filterReq = {
      'Username': KorisnikGlobal.username,
      'KategorijaIncluded': true,
      'OrderBy': '-created'
    };
    await _dogadjajProvider.get(filter: filterReq).then((value) {
      setState(() {
        _kreiranoList = value.result;
        _kreiranoLoaded = true;
      });
    });
    handleLoading();
  }

  loadHistorijaPregleda() async {
    var filterReq = {
      'Username': KorisnikGlobal.username,
      'KategorijaIncluded': true,
      'OrderBy': '-created'
    };
    await _dogadjajProvider.get(filter: filterReq).then((value) {
      setState(() {
        _pregledanoList = value.result;
        _pregledanoLoaded = true;
      });
    });
    handleLoading();
  }

  loadKupljeno() async {
    var filterReq = {
      'Username': KorisnikGlobal.username,
      'KategorijaIncluded': true,
      'OrderBy': '-created'
    };
    await _dogadjajProvider.get(filter: filterReq).then((value) {
      setState(() {
        _kupljenoList = value.result;
        _kupovinaLoaded = true;
      });
    });
    handleLoading();
  }

  handleLoading() {
    if (_kreiranoLoaded && _pregledanoLoaded && _kupovinaLoaded) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  logout() {
    KorisnikGlobal.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        selectedIndex: 3,
        showBackButton: true,
        showAppBar: true,
        child: Expanded(
            child: _isLoading
                ? Container(
                    child: Center(child: const CircularProgressIndicator()))
                : Stack(children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                            child: Column(
                          children: [
                            ClipOval(
                              child: SizedBox.fromSize(
                                  size: Size.fromRadius(48), // Image radius
                                  child: _profilna),
                            ),
                            HeadingWidget(text: _username),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFF28D4F3),
                                    size: 13,
                                  ),
                                  Text(
                                    _lokacija,
                                    style: TextStyle(
                                      color: Color(0xFF28D4F3),
                                      fontFamily: 'Magra',
                                    ),
                                  )
                                ]),
                            SizedBox(
                              height: 40,
                            ),
                            _buildDogadjajiTiles(
                                "Historija kupovine", _kupljenoList),
                            SizedBox(
                              height: 20,
                            ),
                            _buildDogadjajiTiles(
                                "Historija pregleda", _pregledanoList),
                            SizedBox(
                              height: 20,
                            ),
                            _buildDogadjajiTiles(
                                "Kreirani događaji", _kreiranoList),
                          ],
                        ))),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Column(children: [
                          IconButton(
                            icon: Icon(Icons.settings_outlined),
                            color: Color.fromRGBO(60, 71, 92, 1),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EditProfileScreen()),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            color: Color.fromRGBO(60, 71, 92, 1),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        KreirajDogadjajScreen()),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.logout),
                            color: Color.fromRGBO(60, 71, 92, 1),
                            onPressed: () {
                              logout();
                            },
                          ),
                        ]))
                  ])));
  }

  Widget _buildDogadjajiTiles(String naslov, List<Dogadjaj>? dogadjajiList) {
    print("evo događaja ${dogadjajiList?.first.naziv}");
    return Padding(
        padding: EdgeInsets.all(8),
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
            dogadjajiList == null || dogadjajiList.isEmpty
                ? Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Nema rezultata"))
                : Container(
                    height: 240,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        children: dogadjajiList.map((dogadjaj) {
                          print("Dogadjaj: ${dogadjaj.naziv}");
                          return DogadjajVerticalWidget(dogadjaj: dogadjaj);
                        }).toList()),
                  )
          ],
        ));
  }
}
