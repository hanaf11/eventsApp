import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/search_result.dart';

class ZahtjeviListScreen extends StatefulWidget {
  const ZahtjeviListScreen({super.key});

  @override
  State<ZahtjeviListScreen> createState() => _ZahtjeviListScreenState();
}

class _ZahtjeviListScreenState extends State<ZahtjeviListScreen> {
  // int? selected;

  // _ZahtjeviListScreenState(this.selected);

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
          child: Column(
        children: [Text("Zahtjevi screen"), Text("Selected")],
      )),
    );
  }
}
