import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/narudzba.dart';
import 'package:eventsappusers/models/search_result.dart';
import 'package:eventsappusers/models/tipkarte.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:eventsappusers/providers/korisnik_provider.dart';
import 'package:eventsappusers/providers/narudzba_provider.dart';
import 'package:eventsappusers/providers/tipkarte_provider.dart';
import 'package:eventsappusers/screens/personal_information_screen.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
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
  Dogadjaj dogadjaj;
  BuyTicketScreen({super.key, required this.dogadjaj});

  @override
  State<BuyTicketScreen> createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  double _contentHeight = 0;
  String? locationImage = "assets/images/banner.jpg";
  bool isLoading = true;
  bool slikaLoaded = false;
  bool karteLoaded = false;
  late TipkarteProvider _tipKarteProvider;
  late NarudzbaProvider _narudzbaProvider;
  SearchResult<TipKarte>? tipKarteResult;
  bool tipKarteLoaded = false;
  bool dogadjajLoaded = false;
  Image? _lokacijaSlika;
  late List<TipKarte>? karteList;
  Map<int, int> selectedQuantities = {};

  _BuyTicketScreenState();

  @override
  void initState() {
    super.initState();

    _tipKarteProvider = context.read<TipkarteProvider>();
    _narudzbaProvider = context.read<NarudzbaProvider>();
    loadData();
  }

  void loadData() {
    setState(() {
      _lokacijaSlika = imageFromBase64String(widget.dogadjaj.lokacijaSlika);
      slikaLoaded = true;
      handleLoading();
    });

    _tipKarteProvider.get(filter: {
      'DogadjajId': widget.dogadjaj.dogadjajId,
      'Stanje': 0
    }).then((value) {
      setState(() {
        karteList = value.result;
        karteLoaded = true;
        handleLoading();
      });
    });
  }

  void handleException(Exception e) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exception'),
        content: Text(e.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void handleLoading() {
    if (slikaLoaded && karteLoaded) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> validateRequest() async {
    print("selected quantities $selectedQuantities");
    int numOfTickets = 0;
    for (var entry in selectedQuantities.entries) {
      numOfTickets += entry.value;
    }
    if (numOfTickets == 0) {
      handleException(Exception(
          "Morate izabrati bar jednu kartu da biste nastavili kupovinu"));
      return;
    }

    try {
      await _narudzbaProvider.validateRequest(selectedQuantities).then((value) {
        Narudzba narudzba = Narudzba(value);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PersonalInfoScreen(
                  narudzba: narudzba,
                  dogadjaj: widget.dogadjaj,
                )));
      });
    } on Exception catch (ex) {
      handleException(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        selectedIndex: -1,
        showBackButton: true,
        showAppBar: true,
        child: Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                    // Set the initial content height if not already set
                    if (_contentHeight == 0) {
                      _contentHeight = constraints.maxHeight;
                    }
                    return NarudzbaMasterScreen(
                        naslov: 'Kupi kartu',
                        childHeight: _contentHeight,
                        onClickNext: validateRequest,
                        child: SingleChildScrollView(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DogadjajSmallOverview(
                                        naziv: widget.dogadjaj.naziv ?? '',
                                        datumOd: widget.dogadjaj.datumOd ??
                                            DateTime.now(),
                                        lokacija: widget.dogadjaj.lokacija,
                                        naslovna: widget.dogadjaj.naslovna,
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
                                                      image:
                                                          imageFromBase64String(
                                                              widget.dogadjaj
                                                                  .lokacijaSlika),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxHeight: 400),
                                                  child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: Hero(
                                                          tag: 'locationImage',
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child:
                                                                  _lokacijaSlika)))))
                                          : Text("Slika lokacije nije dodana"),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      _buildDostupneKarte(),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ]))));
                  })));
  }

  Column _buildDostupneKarte() {
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
        height: 5,
      ),
      karteList == null || (karteList != null && karteList!.isEmpty)
          ? Padding(
              padding: EdgeInsets.all(4),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Nema dostupnih karata za ovaj događaj')))
          : Column(
              children: karteList!.map((karte) {
                return DostupneKarteWidget(
                    nazivKarte: karte.naziv ?? '',
                    raspolozivo: karte.stanje ?? 0,
                    cijena: karte.cijena ?? 0,
                    stanje: karte.stanje ?? 0,
                    onKolicinaChange: (kolicina) {
                      setState(() {
                        selectedQuantities[karte.tipKarteId!] = kolicina;
                      });
                    });
              }).toList(),
            )
    ]);
  }
}
