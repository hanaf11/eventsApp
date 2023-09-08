import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/search_result.dart';

class KorisniciListScreen extends StatefulWidget {
  int? selected = 2;
  KorisniciListScreen({this.selected, super.key});

  @override
  State<KorisniciListScreen> createState() =>
      _KorisniciListScreenState(selected);
}

class _KorisniciListScreenState extends State<KorisniciListScreen> {
  int? selected;

  _KorisniciListScreenState(this.selected);

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: selected,
      child: Container(
          child: Column(
        children: [Text("Korisnici screen"), Text("Selected ${selected}")],
      )),
    );
  }
}
