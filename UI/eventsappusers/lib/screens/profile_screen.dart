import 'package:eventsappusers/main.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/dogadjaj_vertical.dart';
import '../widgets/master_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "hana123";
  _ProfileScreenState();

  logout() {
    KorisnikGlobal.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

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
                : Stack(children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                            child: Column(
                          children: [
                            ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(48), // Image radius
                                child: Image.asset('assets/images/banner.jpg',
                                    fit: BoxFit.cover),
                              ),
                            ),
                            HeadingWidget(text: username),
                            SizedBox(
                              height: 20,
                            ),
                            _buildDogadjajiTiles("Historija kupovine"),
                            SizedBox(
                              height: 20,
                            ),
                            _buildDogadjajiTiles("Historija pregleda"),
                            SizedBox(
                              height: 0,
                            ),
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
                              Navigator.of(context).pop();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            color: Color.fromRGBO(60, 71, 92, 1),
                            onPressed: () {
                              Navigator.of(context).pop();
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
                    /*  DogadjajVerticalWidget(
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
                    ),*/
                  ]),
            )
          ],
        ));
  }
}
