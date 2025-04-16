import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class NarudzbeIzvjestajScreen extends StatefulWidget {
  int? selected = 6;
  NarudzbeIzvjestajScreen({this.selected, super.key});

  @override
  State<NarudzbeIzvjestajScreen> createState() =>
      _NarudzbeIzvjestajScreenState();
}

class _NarudzbeIzvjestajScreenState extends State<NarudzbeIzvjestajScreen> {
  _NarudzbeIzvjestajScreenState();

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
                  children: [Text("narudzbe izvjestaj")],
                )))));
  }
}
