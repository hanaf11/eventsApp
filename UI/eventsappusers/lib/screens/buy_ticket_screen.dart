import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/search_result.dart';
import 'package:eventsappusers/models/tipkarte.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:eventsappusers/providers/tipkarte_provider.dart';
import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:eventsappusers/widgets/narudzba_master_screen.dart';
import 'package:eventsappusers/widgets/next_step_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/comment_widget.dart';
import '../widgets/dogadjaj_small_overview.dart';
import '../widgets/dostupne_karte.dart';
import '../widgets/full_screen_image.dart';
import '../widgets/master_screen.dart';

class BuyTicketScreen extends StatefulWidget {
  BuyTicketScreen({super.key});

  @override
  State<BuyTicketScreen> createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  double _contentHeight = 0;
  String? locationImage = "assets/images/banner.jpg";
  bool isLoading = true;
  late TipkarteProvider _tipKarteProvider;
  late DogadjajProvider _dogadjajProvider;
  SearchResult<TipKarte>? tipKarteResult;
  Dogadjaj? dogadjaj;
  bool tipKarteLoaded = false;
  bool dogadjajLoaded = false;
  //String? locationImage = null;
  List? karteList = [
    {'nazivKarte': 'Zona B', 'raspolozivo': 5, 'cijena': 15},
    {'nazivKarte': 'Zona A', 'raspolozivo': 10, 'cijena': 30}
  ];

  _BuyTicketScreenState();

  @override
  void initState() {
    super.initState();

    _tipKarteProvider = context.read<TipkarteProvider>();
    _dogadjajProvider = context.read<DogadjajProvider>();
    loadData();
  }

  loadData() {}

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
                    naslov: "Kupi kartu",
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
                      return Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(children: [
                                DogadjajSmallOverview(
                                  naziv: "whatevs",
                                  datumOd: DateTime.now(),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                locationImage != null
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenImage(
                                                tag: 'locationImage',
                                                imagePath: locationImage!,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: 'locationImage',
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.asset(
                                                locationImage!,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                fit: BoxFit.fill,
                                              )),
                                        ))
                                    : Text("Slika lokacije nije dodana"),
                                SizedBox(
                                  height: 25,
                                ),
                                _buildDostupneKarte()
                              ]))
                        ],
                      );
                    }),
                  )));
  }

  _buildDostupneKarte() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Align(
        alignment: Alignment.topLeft,
        child: Text(
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(54, 112, 232, 1),
                letterSpacing: 0.4,
                fontSize: 24),
            "Dostupne karte"),
      ),
      SizedBox(
        height: 10,
      ),
      karteList == null || (karteList != null && karteList!.isEmpty)
          ? Center(
              child: Text('Nema dostupnih karata za ovaj događaj'),
            )
          : Column(
              children: karteList!.map((karte) {
                return DostupneKarteWidget(
                  nazivKarte: karte['nazivKarte'],
                  raspolozivo: karte['raspolozivo'],
                  cijena: (karte['cijena'] as num).toDouble(),
                );
              }).toList(),
            )
    ]);
  }
}
