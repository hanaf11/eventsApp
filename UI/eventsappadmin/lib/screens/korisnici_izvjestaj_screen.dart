import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class KorisniciIzvjestajScreen extends StatefulWidget {
  int? selected = 6;
  KorisniciIzvjestajScreen({this.selected, super.key});

  @override
  State<KorisniciIzvjestajScreen> createState() =>
      _KorisniciIzvjestajScreenState();
}

class _KorisniciIzvjestajScreenState extends State<KorisniciIzvjestajScreen> {
  _KorisniciIzvjestajScreenState();

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: widget.selected,
        child: Expanded(
            child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(vertical: 5),
                child: SingleChildScrollView(
                    child: Column(
                  children: [Text("korisnici izvjestaj")],
                )))));
  }
}
