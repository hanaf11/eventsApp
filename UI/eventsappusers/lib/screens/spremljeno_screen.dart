import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/dogadjaj_horizontal.dart';
import '../widgets/heading_widget.dart';
import '../widgets/master_screen.dart';

class SpremljenoScreen extends StatefulWidget {
  SpremljenoScreen({super.key});

  @override
  State<SpremljenoScreen> createState() => _SpremljenoScreenState();
}

class _SpremljenoScreenState extends State<SpremljenoScreen> {
  late DogadjajProvider _dogadjajProvider;
  bool isLoading = true;
  late List<Dogadjaj>? _savedList;
  _SpremljenoScreenState();

  @override
  void initState() {
    super.initState();
    _dogadjajProvider = context.read<DogadjajProvider>();
    loadData();
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    await _dogadjajProvider.getSaved(KorisnikGlobal.korisnikId).then((value) {
      setState(() {
        _savedList = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        selectedIndex: 2,
        showBackButton: true,
        child: Expanded(
            child: isLoading
                ? Container(
                    child: Center(child: const CircularProgressIndicator()))
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
        child: (_savedList != null && _savedList!.isNotEmpty)
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(5),
                itemCount: _savedList!.length,
                itemBuilder: (BuildContext context, int index) {
                  Dogadjaj d = _savedList![index];
                  return DogadjajHorizontalWidget(
                      dogadjaj: d, reloadPage: loadData);
                },
              )
            : Container(
                child: Text("Nema rezultata"),
              ));
  }
}
