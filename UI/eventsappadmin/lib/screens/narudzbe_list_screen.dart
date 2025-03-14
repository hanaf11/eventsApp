import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/search_result.dart';

class NarudzbeListScreen extends StatefulWidget {
  int? selected = 3;
  NarudzbeListScreen({this.selected, super.key});

  @override
  State<NarudzbeListScreen> createState() => _NarudzbeListScreenState(selected);
}

class _NarudzbeListScreenState extends State<NarudzbeListScreen> {
  int? selected;

  _NarudzbeListScreenState(this.selected);

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return MasterScreenWidget(
      selectedIndex: selected,
      child: isLoading
          ? Expanded(
              child: Container(
                  child: Center(child: const CircularProgressIndicator())))
          : Container(
              child: Column(
              children: [Text("Narudzbe screen"), Text("Selected $selected")],
            )),
    );
  }
}
