import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/search_result.dart';

class NarudzbeListScreen extends StatefulWidget {
  NarudzbeListScreen({super.key});

  @override
  State<NarudzbeListScreen> createState() => _NarudzbeListScreenState();
}

class _NarudzbeListScreenState extends State<NarudzbeListScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
          child: Column(
        children: [Text("Narudzbe screen")],
      )),
    );
  }
}
