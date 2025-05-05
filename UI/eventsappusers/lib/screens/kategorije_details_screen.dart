import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/kategorija.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/models/podkategorija.dart';
import 'package:eventsappusers/models/search_result.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:eventsappusers/providers/kategorije_provider.dart';
import 'package:eventsappusers/providers/pracenje_provider.dart';
import 'package:eventsappusers/utils/style_util.dart';
import 'package:eventsappusers/widgets/dogadjaj_horizontal.dart';
import 'package:eventsappusers/widgets/podkategorije_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../widgets/heading_widget.dart';
import '../widgets/input_field.dart';
import '../widgets/master_screen.dart';

class KategorijeDetailsScreen extends StatefulWidget {
  int kategorijaId;
  KategorijeDetailsScreen({super.key, required this.kategorijaId});

  @override
  State<KategorijeDetailsScreen> createState() =>
      _KategorijeDetailsScreenState();
}

class _KategorijeDetailsScreenState extends State<KategorijeDetailsScreen>
    implements Clearable {
  Podkategorija? _selectedPodkategorija;
  int _selectedPodkategorijaInd = -1;
  bool isLoading = true;
  bool kategorijeLoaded = false;
  bool pracenjeLoaded = false;
  bool dogadjajiLoaded = false;
  late TextEditingController _datumOdController;
  late TextEditingController _datumDoController;
  bool locationFilter = false;
  DateTime? _datumOd;
  DateTime? _datumDo;
  late KategorijeProvider _kategorijaProvider;
  late DogadjajProvider _dogadjajProvider;
  late PracenjeProvider _pracenjeProvider;
  late Kategorija _selectedKategorija;
  late SearchResult? _dogadjajiResult;
  late List<Podkategorija> _podkategorijeList;
  bool pratim = false;
  _KategorijeDetailsScreenState();

  @override
  void initState() {
    super.initState();
    _kategorijaProvider = context.read<KategorijeProvider>();
    _dogadjajProvider = context.read<DogadjajProvider>();
    _pracenjeProvider = context.read<PracenjeProvider>();
    loadData(widget.kategorijaId);
  }

  handleLoading() {
    if (kategorijeLoaded == true &&
        dogadjajiLoaded == true &&
        pracenjeLoaded == true) {
      setState(() {
        isLoading = false;
      });
    }
  }

  handleException(Exception e) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exception'),
        content: Text(e.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  loadData(int id) {
    print("load data called");
    _kategorijaProvider.getById(id).then((value) {
      setState(() {
        _selectedKategorija = value;
        _podkategorijeList = value.podkategorijes ?? [];
        kategorijeLoaded = true;
      });
      handleLoading();
    });
    _dogadjajProvider.get(filter: {
      'Kategorija': widget.kategorijaId,
      'KategorijaIncluded': true,
      'Status': 'ACTIVE'
    }).then((value) {
      setState(() {
        _dogadjajiResult = value;
        dogadjajiLoaded = true;
      });
      print("dogadajaj result je ${_dogadjajiResult}");
      handleLoading();
    });
    _pracenjeProvider.isFollowing({
      'KategorijaId': widget.kategorijaId,
      'KorisnikId': KorisnikGlobal.korisnikId
    }).then((value) {
      setState(() {
        pratim = value;
        pracenjeLoaded = true;
      });
      handleLoading();
    });
  }

  filtriraj() async {
    var myFilter = {
      'Kategorija': widget.kategorijaId,
      'KategorijaIncluded': true,
      'Podkategorija': _selectedPodkategorija?.podkategorijaId,
      'DatumOd': _datumOd,
      'DatumDo': _datumDo,
      'Status': 'ACTIVE'
    };
    var data = await _dogadjajProvider.get(filter: myFilter);
    setState(() {
      _dogadjajiResult = data;
    });
  }

  void _handleSelection(Podkategorija? p, int index) {
    setState(() {
      _selectedPodkategorija = p;
      _selectedPodkategorijaInd = index;
    });
    filtriraj();
  }

  void _showDatePicker(caller) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime(2030))
        .then((value) {
      if (value != null) {
        setState(() {
          if (caller == "_datumOd") {
            _datumOd = value;
          } else {
            _datumDo = DateTime(value.year, value.month, value.day, 23, 59, 59);
          }
        });
      }
    });
  }

  follow() async {
    bool? value;
    var request = {
      "KategorijaId": _selectedKategorija.kategorijaId,
      "KorisnikId": KorisnikGlobal.korisnikId
    };
    try {
      if (!pratim) {
        value = await _pracenjeProvider.follow(request);
      } else {
        value = await _pracenjeProvider.unfollow(request);
      }
    } on Exception catch (e) {
      handleException(e);
    }
    setState(() {
      pratim = value ?? pratim;
    });
  }

  @override
  clear(dynamic input) {
    if (input is TextField) {
      if (input.key != null) {
        String keyName = input.key!.toString().replaceAll(RegExp(r"[<'>]"), '');
        keyName = keyName.substring(1, keyName.length - 1);
        if (keyName == '_datumOd') {
          setState(() {
            _datumOd = null;
          });
        }
        if (keyName == '_datumDo') {
          setState(() {
            _datumDo = null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? MasterScreen(
            selectedIndex: -1,
            showBackButton: true,
            showFollowButton: false,
            child: Expanded(
                child: Container(
                    child: Center(child: const CircularProgressIndicator()))))
        : MasterScreen(
            selectedIndex: 0,
            showBackButton: true,
            showFollowButton: true,
            following: pratim,
            followFunc: follow,
            child: Expanded(
                child: Column(
              children: [
                HeadingWidget(text: _selectedKategorija.naziv ?? ''),
                _buildFilters(),
                SizedBox(
                  height: 20,
                ),
                if (_dogadjajiResult != null &&
                    _dogadjajiResult!.result.isNotEmpty)
                  _buildDogadjajiTiles()
              ],
            )));
  }

  Widget _buildFilters() {
    return Column(
      children: [
        _buildPodkategorijeList(),
        _buildDateSearch(),
        Row(
          children: [
            Expanded(
              child: _buildLocationCheckbox(),
            ),
            Expanded(
                child: ElevatedButton(
              onPressed: () => filtriraj(),
              child: Text("Filtriraj"),
              style: buttonPrimary,
            ))
          ],
        )
      ],
    );
  }

  Container _buildPodkategorijeList() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15.0),
      height: 35,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(_podkategorijeList.length, (index) {
            return PodkategorijaTile(
                text: _podkategorijeList[index].naziv,
                isSelected: _selectedPodkategorijaInd == index,
                onSelect: (isSelected) => {
                      _handleSelection(
                          isSelected ? _podkategorijeList[index] : null,
                          isSelected ? index : -1)
                    });
          })),
    );
  }

  Widget _buildDateSearch() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 33,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: InputField(
              name: "Od:",
              field: TextField(
                style: const TextStyle(
                    color: Color.fromRGBO(68, 68, 68, 1),
                    fontSize: 14,
                    letterSpacing: 0.3,
                    fontFamily: 'Montserrat'),
                decoration: InputDecoration.collapsed(hintText: 'Datum od'),
                controller: _datumOdController = TextEditingController(
                    text: _datumOd == null
                        ? ""
                        : "${_datumOd?.day}.${_datumOd?.month}.${_datumOd?.year}."),
                readOnly: true,
                key: const Key("_datumOd"),
                onTap: () {
                  _showDatePicker("_datumOd");
                },
              ),
              clearable: this,
            )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: InputField(
              name: "Do:",
              field: TextField(
                style: const TextStyle(
                    color: Color.fromRGBO(68, 68, 68, 1),
                    fontSize: 14,
                    letterSpacing: 0.3,
                    fontFamily: 'Montserrat'),
                decoration: InputDecoration.collapsed(hintText: 'Datum do'),
                controller: _datumDoController = TextEditingController(
                    text: _datumDo == null
                        ? ""
                        : "${_datumDo?.day}.${_datumDo?.month}.${_datumDo?.year}."),
                readOnly: true,
                key: const Key("_datumDo"),
                onTap: () {
                  _showDatePicker("_datumDo");
                },
              ),
              clearable: this,
            )),
          ],
        ));
  }

  CheckboxListTile _buildLocationCheckbox() {
    return CheckboxListTile(
      title: const Text(
        "Filtriraj najbliže meni",
        style: TextStyle(
            color: Color.fromRGBO(68, 68, 68, 1),
            fontSize: 14,
            letterSpacing: 0.3,
            fontFamily: 'Montserrat'),
      ),
      value: locationFilter,
      onChanged: (newValue) {
        setState(() {
          locationFilter = !locationFilter;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  _buildDogadjajiTiles() {
    return Expanded(
      child: ListView.builder(
          itemCount: _dogadjajiResult?.count,
          itemBuilder: (BuildContext context, int index) {
            Dogadjaj d = _dogadjajiResult?.result[index];
            return DogadjajHorizontalWidget(dogadjaj: d);
          }),
    );
  }
}
