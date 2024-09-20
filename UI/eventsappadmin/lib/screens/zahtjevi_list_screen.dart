import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/search_result.dart';

class ZahtjeviListScreen extends StatefulWidget {
  int? selected = 1;
  ZahtjeviListScreen({this.selected, super.key});

  @override
  State<ZahtjeviListScreen> createState() =>
      // ignore: no_logic_in_create_state
      _ZahtjeviListScreenState(selected: selected);
}

class _ZahtjeviListScreenState extends State<ZahtjeviListScreen> {
  int? selected = 1;
  bool _isLoading = true;
  late DogadjajProvider _dogadjajProvider;
  List<Dogadjaj>? _zahtjeviList;
  _ZahtjeviListScreenState({this.selected});

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: selected,
        child: Expanded(
            child: // _isLoading ?
                //const CircularProgressIndicator() :
                Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(children: [
                          const Text(
                            "Zahtjevi za kreiranje događaja",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 62, 62, 62),
                            ),
                          ),
                          /*Divider(
                          color: const Color.fromARGB(255, 81, 81, 81),
                          height: 10, // Adjust the height as needed
                          thickness: 1, // Adjust the thickness as needed
                          indent: 10, // Adjust the indent as needed
                          endIndent: 10, // Adjust the end indent as needed
                        )*/
                        ])))));
  }
}
