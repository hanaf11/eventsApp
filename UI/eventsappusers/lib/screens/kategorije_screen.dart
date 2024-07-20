import 'package:eventsappusers/providers/kategorije_provider.dart';
import 'package:eventsappusers/screens/kategorije_details_screen.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:eventsappusers/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/kategorija.dart';

class KategorijeScreen extends StatefulWidget {
  const KategorijeScreen({super.key});

  @override
  State<KategorijeScreen> createState() => _KategorijeScreenState();
}

class _KategorijeScreenState extends State<KategorijeScreen> {
  bool isLoading = true;
  late KategorijeProvider _kategorijeProvider;
  List<Kategorija> _kategorijeList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _kategorijeProvider = context.read<KategorijeProvider>();
    getKategorije();
  }

  getKategorije() async {
    var kategorijeResult = await _kategorijeProvider.get();
    setState(() {
      _kategorijeList = kategorijeResult.result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        selectedIndex: 0,
        showBackButton: true,
        child: Expanded(
            child: isLoading
                ? Container(
                    child: Center(child: const CircularProgressIndicator()))
                : Column(
                    children: [
                      const HeadingWidget(text: "Odaberite kategoriju"),
                      Container(
                        height: 10,
                      ),
                      if (_kategorijeList.isNotEmpty)
                        _buildTilesList(_kategorijeList)
                    ],
                  )));
  }

  Widget _buildTilesList(List<Kategorija> resultList) {
    return Expanded(
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: resultList
                      .map((e) => _buildTile(e))
                      .toList()
                      .cast<Widget>()))
        ],
      ),
    );

    ;
  }

  Widget _buildTile(Kategorija e) {
    return InkWell(
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: imageProviderFromBase64String(e.slika),
                    fit: BoxFit.cover)),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      e.naziv!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Magra',
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: Color.fromARGB(255, 72, 71, 71),
                            blurRadius: 3.0,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    )))),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => KategorijeDetailsScreen(
                      kategorijaId: e.kategorijaId!,
                    )),
          );
        });
  }
}
