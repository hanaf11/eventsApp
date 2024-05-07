import 'package:flutter/material.dart';

import '../widgets/dogadjaj_horizontal.dart';
import '../widgets/heading_widget.dart';
import '../widgets/master_screen.dart';

class SpremljenoScreen extends StatefulWidget {
  SpremljenoScreen({super.key});

  @override
  State<SpremljenoScreen> createState() => _SpremljenoScreenState();
}

class _SpremljenoScreenState extends State<SpremljenoScreen> {
  _SpremljenoScreenState();

  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    return MasterScreen(
        selectedIndex: 2,
        showBackButton: true,
        //showFollowButton: false,
        child: Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      HeadingWidget(text: "Spremljeno"),
                      Container(
                        height: 20,
                      ),
                      _buildDogadjajiTiles()
                    ],
                  )));
  }

  _buildDogadjajiTiles() {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          DogadjajHorizontalWidget(
            naslov: "Test naslov",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Spanija",
            saved: true,
          ),
          DogadjajHorizontalWidget(
            naslov:
                "TBosnian pyramids show in pyramid valley in visoko pls come hey hi hello hahaahha",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Visoko, BIH",
            saved: true,
          ),
          DogadjajHorizontalWidget(
            naslov: "Queen tribute",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Sarajevo, BiH",
            saved: true,
          ),
          DogadjajHorizontalWidget(
            naslov: "Test naslov",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Spanija",
            saved: true,
          ),
          DogadjajHorizontalWidget(
            naslov: "Test naslov",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Spanija",
            saved: true,
          ),
          DogadjajHorizontalWidget(
            naslov: "Test naslov",
            datumOd: DateTime.now(),
            datumDo: DateTime.now(),
            kategorija: "Konferencije",
            lokacija: "Spanija",
            saved: true,
          ),
        ],
      ),
    );
  }
}
