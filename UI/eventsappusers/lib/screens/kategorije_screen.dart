import 'package:eventsappusers/providers/auth_provider.dart';
import 'package:eventsappusers/providers/kategorije_provider.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:eventsappusers/utils/util.dart';
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
  late KategorijeProvider provider;
  List<Kategorija> kategorijeList = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<KategorijeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    return MasterScreen(
        selectedIndex: 0,
        showBackButton: true,
        child: Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      HeadingWidget(text: "Odaberite kategoriju"),
                      Container(
                        height: 10,
                      ),
                      /*   Expanded(
                        child: Row(
                          children: [
                            TextField(
                              controller: _searchController,
                            ),
                          
                          ],
                        ),
                      ),*/
                      ElevatedButton(
                          onPressed: () async {
                            var filter = {"fts": _searchController.text};
                            var result = await provider.get(filter: filter);
                            print(result);
                            setState(() {
                              kategorijeList = result.result;
                            });
                          },
                          child: Text("dobavi")),
                      _buildTilesList(kategorijeList)
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
                      .map((e) => _buildTile(e.naziv))
                      .toList()
                      .cast<Widget>()))
        ],
      ),
    );

    ;
  }

  Widget _buildTile(text) {
    return Container(
        padding: const EdgeInsets.all(8),
        // color: Colors.green[400],
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.green[400],
            image: DecorationImage(
              //image: slika!="" ? imageFromString(slika).image : AssetImage("assets/images/banner.jpg"),

              image: AssetImage("assets/images/banner.jpg"),
              fit: BoxFit.cover,
            )),
        child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
                padding: const EdgeInsets.all(5.0), // Adjust as needed
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white, // Text color
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
                ))));
  }
}
