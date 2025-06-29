import 'package:eventsappusers/models/dogadjaj.dart';
import 'package:eventsappusers/models/komentar.dart';
import 'package:eventsappusers/models/korisnik.dart';
import 'package:eventsappusers/models/korisnik_global.dart';
import 'package:eventsappusers/models/podkategorija.dart';
import 'package:eventsappusers/models/slika.dart';
import 'package:eventsappusers/providers/dogadjaj_provider.dart';
import 'package:eventsappusers/providers/galerija_provider.dart';
import 'package:eventsappusers/providers/komentari_provider.dart';
import 'package:eventsappusers/providers/podkategorija_provider.dart';
import 'package:eventsappusers/providers/saving_provider.dart';
import 'package:eventsappusers/screens/buy_ticket_screen.dart';
import 'package:eventsappusers/utils/category_color_util.dart';
import 'package:eventsappusers/utils/formatting_util.dart';
import 'package:eventsappusers/utils/util.dart';
import 'package:eventsappusers/widgets/comment_widget.dart';
import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:eventsappusers/widgets/input_field.dart';
import 'package:eventsappusers/widgets/podkategorije_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventsappusers/utils/style_util.dart';

import '../widgets/full_screen_image.dart';
import '../widgets/master_screen.dart';
import '../widgets/photo_gallery.dart';

import 'package:latlong2/latlong.dart';
import 'package:latlong2/spline.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';

class EventDetailsScreen extends StatefulWidget {
  int dogadjajId;
  EventDetailsScreen({super.key, required this.dogadjajId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool saved = false;
  bool isLoading = true;
  bool dogadjajLoaded = false;
  bool podkategorijaLoaded = false;
  bool komentariLoaded = false;
  bool savingLoaded = false;
  bool galerijaLoaded = false;
  late DogadjajProvider _dogadjajProvider;
  late PodkategorijaProvider _podkategorijaProvider;
  late KomentariProvider _komentariProvider;
  late SavingProvider _savingProvider;
  late GalerijaProvider _galerijaProvider;
  late Dogadjaj _dogadjaj;
   Podkategorija? _podkategorija;
  TextEditingController _komentarController = new TextEditingController();
  late List<Komentar>? _komentariList;
  late List<Slika>? _galerija;
  late List<ImageObj>? imageList;

  _EventDetailsScreenState();

  @override
  void initState() {
    super.initState();
    _dogadjajProvider = context.read<DogadjajProvider>();
    _podkategorijaProvider = context.read<PodkategorijaProvider>();
    _komentariProvider = context.read<KomentariProvider>();
    _savingProvider = context.read<SavingProvider>();
    _galerijaProvider = context.read<GalerijaProvider>();
    loadData();
  }

  handleLoading() {
    if (dogadjajLoaded == true &&
        podkategorijaLoaded == true &&
        komentariLoaded == true &&
        savingLoaded == true &&
        galerijaLoaded == true) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSuccessDialog(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Success"),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            ));
  }

  loadData() {
    _dogadjajProvider.getById(widget.dogadjajId).then((value) {
      setState(() {
        _dogadjaj = value;
        print("evo ga dogadjaj ${_dogadjaj.naziv}");
        dogadjajLoaded = true;
      });

      print("podkategorija ${_dogadjaj.podkategorijaId}");
      if(_dogadjaj.podkategorijaId!=null){
      _podkategorijaProvider
          .getById(_dogadjaj.podkategorijaId)
          .then((podkategorijaValue) {
        setState(() {
          _podkategorija = podkategorijaValue;
          podkategorijaLoaded = true;
          print("evo ga podkategorija ${_podkategorija?.naziv}");
        });
        handleLoading();
          });
      } else {podkategorijaLoaded=true; handleLoading();}

        _komentariProvider
            .get(filter: {'dogadjajId': widget.dogadjajId}).then((value) {
          setState(() {
            _komentariList = value.result;
            komentariLoaded = true;
          });
          handleLoading();
        });

        _savingProvider.isSaved({
          'DogadjajId': widget.dogadjajId,
          'KorisnikId': KorisnikGlobal.korisnikId
        }).then((value) {
          setState(() {
            saved = value;
            savingLoaded = true;
          });
          handleLoading();
        });

        _galerijaProvider
            .get(filter: {'DogadjajId': widget.dogadjajId}).then((value) {
          setState(() {
            _galerija = value.result;
            galerijaLoaded = true;
          });
          handleLoading();
        });
      }).catchError((e) {
        handleException(e);
      });
    
  }

  Future<void> showKomentariDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dodaj komentar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _komentarController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Pošalji'),
              onPressed: () {
                var request = {
                  'dogadjajId': widget.dogadjajId,
                  'korisnikId': KorisnikGlobal.korisnikId,
                  'komentar': _komentarController.text
                };
                try {
                  _komentariProvider.post(request).then(
                    (value) {
                      showSuccessDialog("Komentar uspješno dodan");
                      setState(() {
                        _komentariList = value.result;
                      });
                    },
                  );
                } on Exception catch (e) {
                  handleException(e);
                }
              },
            ),
          ],
        );
      },
    );
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

  void _handleSelection(int index) {}

  _savedClicked() async {
    bool? value;
    var request = {
      "DogadjajId": widget.dogadjajId,
      "KorisnikId": KorisnikGlobal.korisnikId
    };
    try {
      if (!saved) {
        value = await _savingProvider.save(request);
      } else {
        value = await _savingProvider.delete(request);
      }
    } on Exception catch (e) {
      handleException(e);
    }
    setState(() {
      saved = value ?? saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("loaded $podkategorijaLoaded");
    print("podkat $_podkategorija" );
    return MasterScreen(
        selectedIndex: -1,
        showBackButton: true,
        showAppBar: false,
        child: Expanded(
          child: isLoading
              ? Container(
                  child: Center(child: const CircularProgressIndicator()))
              : Stack(children: [
                  ListView(scrollDirection: Axis.vertical, children: [
                    SizedBox(
                        height: 200,
                        child: imageFromBase64String(_dogadjaj.naslovna)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            iconSize: 22,
                            onPressed: () {
                              if (_dogadjaj.dobavljacId == null) {
                                handleException(Exception(
                                    "Za ovaj događaj se ne prodaju karte"));
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BuyTicketScreen(dogadjaj: _dogadjaj)),
                                );
                              }
                            },
                            icon: Icon(
                              Icons.shopping_bag_outlined,
                              color: Color.fromRGBO(60, 71, 92, 1),
                            )),
                        IconButton(
                            iconSize: 22,
                            onPressed: () {
                              _savedClicked();
                            },
                            icon: saved
                                ? Icon(
                                    Icons.bookmark_outlined,
                                    color: Color.fromRGBO(60, 71, 92, 1),
                                  )
                                : Icon(
                                    Icons.bookmark_outline_outlined,
                                    color: Color.fromRGBO(60, 71, 92, 1),
                                  ))
                      ],
                    ),
                    HeadingWidget(text: _dogadjaj.naziv ?? ''),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildKategorija(),
                                SizedBox(
                                  width: 5,
                                ),
                                if( podkategorijaLoaded== true && _podkategorija!=null) 
                                PodkategorijaTile(
                                    text: _podkategorija?.naziv ?? "",
                                    isSelected: false,
                                    onSelect: (isSelected) =>
                                        {_handleSelection(-1)})
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.access_alarm_outlined,
                                  color: Color.fromRGBO(60, 71, 92, 1),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  formatDate(
                                          _dogadjaj.datumOd ?? DateTime.now()) +
                                      " - " +
                                      formatDate(
                                          _dogadjaj.datumDo ?? DateTime.now()),
                                  style: TextStyle(
                                      color: Color.fromRGBO(60, 71, 92, 1),
                                      fontSize: 14,
                                      letterSpacing: 0.7,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Color.fromRGBO(60, 71, 92, 1),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _dogadjaj.lokacija ?? '',
                                  style: TextStyle(
                                      color: Color.fromRGBO(60, 71, 92, 1),
                                      fontSize: 13,
                                      letterSpacing: 0.7,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.language,
                                  color: Color.fromRGBO(60, 71, 92, 1),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _dogadjaj.website ?? '',
                                  style: TextStyle(
                                      color: Color.fromRGBO(113, 126, 148, 1),
                                      fontSize: 12,
                                      letterSpacing: 0.7,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _buildNaslov("Opis"),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  _dogadjaj.opis ?? '',
                                  style: paragaph,
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            _buildNaslov("Program"),
                            if (_dogadjaj.programSlika != null &&
                                _dogadjaj.programSlika!.isNotEmpty)
                              _buildProgramSlika(),
                            if (_dogadjaj.program != null)
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(_dogadjaj.program ?? '',
                                      style: paragaph)),
                            SizedBox(
                              height: 20,
                            ),
                            _buildGalerija(),
                            _buildNaslov("Prikaži na mapi"),
                            _buildMap(_dogadjaj.lokacija),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildNaslov("Komentari"),
                                InkWell(
                                  child: Text(
                                    "+ Dodaj komentar",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Montserrat',
                                        letterSpacing: 0.3,
                                        color: Color.fromRGBO(54, 112, 232, 1)),
                                  ),
                                  onTap: () {
                                    showKomentariDialog();
                                  },
                                )
                              ],
                            ),
                            _buildKomentari(),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(4, 4),
                                  ),
                                ], borderRadius: BorderRadius.circular(20)),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_dogadjaj.dobavljacId == null) {
                                      handleException(Exception(
                                          "Za ovaj događaj se ne prodaju karte"));
                                    } else {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BuyTicketScreen(
                                                    dogadjaj: _dogadjaj)),
                                      );
                                    }
                                  },
                                  child: Text("Kupi kartu"),
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.grey,
                                      backgroundColor:
                                          Color.fromRGBO(44, 152, 240, 1),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 70, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold)),
                                )),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        )),
                  ]),
                  Positioned(
                      top: 16.0,
                      left: 0,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Color.fromRGBO(60, 71, 92, 1),
                        onPressed: () {
                          print("kliknuto pop");
                          Navigator.pop(context, true);
                        },
                      )),
                ]),
        ));
  }

  Widget _buildNaslov(String text) {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(54, 112, 232, 1),
                letterSpacing: 0.4,
                fontSize: 24),
            text));
  }

  Widget _buildGalerija() {
    List<ImageObj>? imageList = imageListFromBase64String(_galerija);
    if (imageList != null && imageList.isNotEmpty) {
      return Column(
        children: [
          _buildNaslov("Galerija"),
          PhotoGallery(imageList: imageList),
          SizedBox(
            height: 30,
          )
        ],
      );
    } else
      return Container();
  }

  Widget _buildProgramSlika() {
    Image programSlika = imageFromBase64String(_dogadjaj.programSlika);
    String tag = "programSlika";
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FullScreenImage(tag: tag, image: programSlika),
            ),
          );
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Hero(
                tag: tag, child: SizedBox(height: 170, child: programSlika))));
  }

  /*Widget _buildKomentari() {
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: commentList.length,
            itemBuilder: (context, index) {
              final comment = commentList[index];
              return CommentWidget(
                username: comment['username']!,
                text: comment['text']!,
              );
            }));
  }
*/
  Widget _buildKomentari() {
    if (_komentariList == null || _komentariList!.isEmpty) {
      return Center(
        child: Text(
          'Nema komentara',
          style: paragaph,
        ),
      );
    }

    return Column(
      children: _komentariList!.map((comment) {
        return CommentWidget(
          username: comment.korisnik?.korisnickoIme ?? 'Unknown user',
          text: comment.komentar ?? 'No text',
        );
      }).toList(),
    );
  }

  _buildKategorija() {
    Color categoryColor =
        CategoryColorManager().getColorForCategory(_dogadjaj!.kategorijaId!);
    return Text(
      _dogadjaj!.kategorija!.naziv ?? '',
      style: TextStyle(
          color: categoryColor,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          fontSize: 14),
    );
  }
}

Widget _buildMap(String? lokacija) {
  if (lokacija == null) return Text("Greška prilikom učitavanja lokacije");
  return FutureBuilder(
    future: locationFromAddress(lokacija),
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Could not load map', style: paragaph);
      } else {
        var locations = snapshot.data;
        var output = 'No results found.';
        if (locations != null && locations.isNotEmpty) {
          late LatLng center;
          output = locations[0].toString();
          center = _extractLatitudeLongitude(output);

          return Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: center,
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.location_pin,
                          size: 40,
                          color: Color.fromRGBO(227, 48, 71, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        } else {
          return Container();
        }
      }
    },
  );
}

LatLng _extractLatitudeLongitude(String output) {
  String latitudeKey = 'Latitude: ';
  String longitudeKey = 'Longitude: ';

  int latitudeStartIndex = output.indexOf(latitudeKey) + latitudeKey.length;
  int longitudeStartIndex = output.indexOf(longitudeKey) + longitudeKey.length;

  int latitudeEndIndex = output.indexOf(',', latitudeStartIndex);
  int longitudeEndIndex = output.indexOf(',', longitudeStartIndex);

  String lat = output.substring(latitudeStartIndex, latitudeEndIndex).trim();
  String long = output.substring(longitudeStartIndex, longitudeEndIndex).trim();

  print("lat ${double.parse(lat)} long ${double.parse(long)}");
  return LatLng(double.parse(lat), double.parse(long));
}
