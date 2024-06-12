import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:eventsappusers/widgets/dogadjaj_small_overview.dart';
import 'package:eventsappusers/widgets/input_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/master_screen.dart';
import '../widgets/narudzba_master_screen.dart';
import 'package:country_picker/country_picker.dart';

class NarudzbaPreviewScreen extends StatefulWidget {
  NarudzbaPreviewScreen({super.key});

  @override
  State<NarudzbaPreviewScreen> createState() => _NarudzbaPreviewScreenState();
}

class _NarudzbaPreviewScreenState extends State<NarudzbaPreviewScreen> {
  double _contentHeight = 0;

  DateTime datumOd = DateTime.now();
  var tickets = [
    {'naziv': 'Zona B', 'kolicina': 1, 'cijena': 15},
    {'naziv': 'Zona A', 'kolicina': 5, 'cijena': 30}
  ];

  late final double _ukupno = 0;

  double _calcUkupno() {
    double ukupno = 0;
    tickets.forEach((e) {
      ukupno += (e['kolicina'] as int) * (e['cijena'] as double);
    });
    return ukupno;
  }

  _NarudzbaPreviewScreenState();

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
                    naslov: "Narudžba",
                    childHeight: _contentHeight,
                    tabActive: 3,
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
                                  DogadjajSmallOverview(
                                      naziv: 'Test događaj',
                                      datumOd: datumOd,
                                      tickets: tickets,
                                      ukupno: _ukupno),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  _buildLicniPodaci(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _buildPlacanjePodaci(),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Center(
                                      child: _buildHeading(
                                          "Ukupno za platiti: ${formatNumber(_ukupno)}KM"))
                                ]),
                          ));
                    }))));
  }

  _buildLicniPodaci() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading("Lični podaci"),
        Text(
          "Ime prezime",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromRGBO(60, 71, 92, 1),
              fontSize: 15,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3),
        ),
        Text(
          "Adresa 1",
          style: _myTextStyle,
        ),
        Text(
          "Adresa 2",
          style: _myTextStyle,
        ),
        Text(
          "Država",
          style: _myTextStyle,
        ),
        Text(
          "Telefon",
          style: _myTextStyle,
        ),
        Text(
          "Mail",
          style: _myTextStyle,
        ),
        Row(
          children: [
            Text(
              "Način preuzimanja: ",
              style: _myTextStyle,
            ),
            Text(
              "Poštom",
              style: _myTextStyle,
            ),
          ],
        )
      ],
    );
  }

  TextStyle _myTextStyle = TextStyle(
      color: Color.fromRGBO(60, 71, 92, 1),
      fontSize: 15,
      fontFamily: 'Montserrat',
      letterSpacing: 0.3);

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

  _buildPlacanjePodaci() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildHeading("Plaćanje"),
      Text(
        "Paypal",
        style: _myTextStyle,
      )
    ]);
  }
}
