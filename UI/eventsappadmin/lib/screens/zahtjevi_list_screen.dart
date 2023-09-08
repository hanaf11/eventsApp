import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/search_result.dart';

class ZahtjeviListScreen extends StatefulWidget {
  int? selected = 0;
  ZahtjeviListScreen({this.selected, super.key});

  @override
  State<ZahtjeviListScreen> createState() =>
      // ignore: no_logic_in_create_state
      _ZahtjeviListScreenState(selected: selected);
}

class _ZahtjeviListScreenState extends State<ZahtjeviListScreen> {
  int? selected = 1;

  _ZahtjeviListScreenState({this.selected});

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: selected,
      child: Container(
          child: Column(
        children: [Text("Zahtjevi screen"), Text("Selected ${selected}")],
      )),
    );
  }
}
