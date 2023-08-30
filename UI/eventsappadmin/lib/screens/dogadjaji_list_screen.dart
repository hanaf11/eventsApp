import 'package:eventsappadmin/providers/dogadjaj_provider.dart';
import 'package:eventsappadmin/screens/dogadjaj_details_screen.dart';
import 'package:eventsappadmin/utils/util.dart';
import 'package:eventsappadmin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dogadjaj.dart';
import '../models/search_result.dart';

class DogadjajiListScreen extends StatefulWidget {
  const DogadjajiListScreen({super.key});

  @override
  State<DogadjajiListScreen> createState() => _DogadjajiListScreenState();
}

class _DogadjajiListScreenState extends State<DogadjajiListScreen> {
  late DogadjajProvider _dogadjajProvider;
  SearchResult<Dogadjaj>? result;
  TextEditingController _ftsController = new TextEditingController();
  TextEditingController _kategorijaController = new TextEditingController();
  TextEditingController _lokacijaController = new TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dogadjajProvider = context.read<DogadjajProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
          child: Column(
        children: [_buildSearch(), _buildDataListView()],
      )),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                _buildSearchField(
                    "Kategorija:",
                    TextField(
                      decoration: InputDecoration(labelText: "Kategorija:"),
                      controller: _kategorijaController,
                    )),
                _buildSearchField(
                    "Od:",
                    TextField(
                      decoration: InputDecoration(labelText: "Od:"),
                    )),
              ],
            ),
            width: 800,
          ),
          Container(
            child: Row(
              children: [
                _buildSearchField(
                    "Lokacija:",
                    TextField(
                      decoration: InputDecoration(labelText: "Lokacija:"),
                      controller: _lokacijaController,
                    )),
                _buildSearchField("Do:",
                    TextField(decoration: InputDecoration(labelText: "Do:"))),
              ],
            ),
            width: 800,
          ),
          Container(
            child: Row(
              children: [
                _buildSearchField(
                    "Naziv:",
                    TextField(
                      decoration: InputDecoration(labelText: "Naziv:"),
                      controller: _ftsController,
                    )),
                _buildSearchField(
                    "Organizator:",
                    TextField(
                        decoration:
                            InputDecoration(labelText: "Organizator:"))),
                ElevatedButton(
                    child: Text("Pretraga"),
                    onPressed: () async {
                      var data = await _dogadjajProvider.get(filter: {
                        'fts': _ftsController.text,
                        'kategorija': _kategorijaController.text,
                        'lokacija': _lokacijaController.text
                      });

                      setState(() {
                        result = data;
                      });

                      //print("data ${data.result[0].naziv}");
                    }),
              ],
            ),
            width: 850,
          ),
        ],
      ),
    );
    /*ElevatedButton(
      child: Text("Get"),
      onPressed: () async {
        var data = await _dogadjajProvider.get();

        setState(() {
          result = data;
        });

        print("data ${data.result[0].naziv}");
      },
    );*/
  }

  Widget _buildSearchField(String name, Widget field) {
    return Expanded(
        child: Row(children: [
      Text(name),
      SizedBox(
        width: 8,
      ),
      Expanded(child: field),
      SizedBox(
        width: 50,
      ),
    ]));
  }

  Expanded _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: [
            DataColumn(
              label: Expanded(
                child: Text(
                  'ID',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Naziv',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Opis',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            /* DataColumn(
              label: Expanded(
                child: Text(
                  'Slika',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),*/
          ],
          rows: result?.result
                  .map((Dogadjaj e) => DataRow(
                          onSelectChanged: (selected) => {
                                if (selected == true)
                                  {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DogadjajiDetailsScreen(dogadjaj: e),
                                      ),
                                    )
                                  }
                              },
                          cells: [
                            DataCell(Text(e.dogadjajId?.toString() ?? "")),
                            DataCell(Text(e.naziv?.toString() ?? "")),
                            DataCell(Text(e.opis?.toString() ?? "")),
                            // DataCell(Text(formatNumber(e.cijena) ?? "")),
                            /* DataCell(e.naslovna!=""?Container(
                          width: 100,
                          height: 100,
                          child: imageFromBase64String(e.naslovna!):Text(""),
                        ))*/
                          ]))
                  .toList() ??
              []),
    ));
  }
}
