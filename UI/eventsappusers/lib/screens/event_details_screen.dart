import 'package:eventsappusers/widgets/comment_widget.dart';
import 'package:eventsappusers/widgets/heading_widget.dart';
import 'package:eventsappusers/widgets/podkategorije_tile.dart';
import 'package:flutter/material.dart';

import '../widgets/full_screen_image.dart';
import '../widgets/master_screen.dart';
import '../widgets/photo_gallery.dart';

import 'package:latlong2/latlong.dart';
import 'package:latlong2/spline.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  DateTime datumOd = DateTime.now();
  DateTime datumDo = DateTime.now();
  String opis =
      "Omladinski Film Festival Sarajevo se ove godine vraća u velikom stilu. Dvije otvorene kino lokacije - jedna nova koju ćete apsolutno voljeti! Preko 40 filmova, više od 200 gostiju, blizu 8000 hiljada posjetilaca. Dva koncerta, dva partija i mnogo dobrih filmova i zabave! Program i detalji dostupni na www.omladinski.ba od 01.06.2022.godine.";
  String program =
      "Omladinski Film Festival Sarajevo se ove godine vraća u velikom stilu. Dvije otvorene kino lokacije - jedna nova koju ćete apsolutno voljeti! Preko 40 filmova, više od 200 gostiju, blizu 8000 hiljada posjetilaca. Dva koncerta, dva partija i mnogo dobrih filmova i zabave! Program i detalji dostupni na www.omladinski.ba od 01.06.2022.godine.";
  String lokacija = "Visoko";
  bool saved = false;

  _EventDetailsScreenState();

  void _handleSelection(int index) {}

  final List<String> imageList = [
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',

    // Add more image paths
  ];

  final commentList = [
    {'username': 'John Doe', 'text': 'This is a comment'},
    {'username': 'Jane Smith', 'text': 'This is another comment'},
    {'username': 'Alice Johnson', 'text': 'Yet another comment'},
  ];

  List months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];

  _savedClicked() {
    setState(() {
      saved = !saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    return MasterScreen(
        selectedIndex: 0,
        showBackButton: true,
        showAppBar: false,
        child: Expanded(
          child: isLoading
              ? const CircularProgressIndicator()
              : Stack(children: [
                  ListView(scrollDirection: Axis.vertical, children: [
                    Image.asset('assets/images/banner.jpg',
                        height: 210, fit: BoxFit.cover),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            iconSize: 22,
                            onPressed: () {},
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
                    HeadingWidget(
                        text: "14. Omladinski film festival u Sarajevu"),
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
                                Text(
                                  "Festival",
                                  style: TextStyle(
                                      color: Color.fromRGBO(227, 48, 70, 1),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                PodkategorijaTile(
                                    text: "Film",
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
                                  datumOd.day.toString() +
                                      ". " +
                                      months[datumOd.month - 1] +
                                      " - " +
                                      datumDo.day.toString() +
                                      ". " +
                                      months[datumDo.month - 1] +
                                      " " +
                                      datumDo.year.toString(),
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
                                  "Pozoriste Mladih Sarajevo",
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
                                  "www.omladinski.ba",
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
                            Text(
                              opis,
                              style: TextStyle(
                                  color: Color.fromRGBO(60, 71, 92, 1),
                                  fontSize: 12,
                                  letterSpacing: 0.3,
                                  fontFamily: 'Montserrat'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _buildNaslov("Program"),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenImage(
                                        tag: 'bannerImage',
                                        imagePath: 'assets/images/banner.jpg',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Hero(
                                        tag: 'bannerImage',
                                        child: Image.asset(
                                          'assets/images/banner.jpg',
                                          height: 170,
                                          fit: BoxFit.cover,
                                        )))),
                            if (program != null)
                              SizedBox(
                                height: 10,
                              ),
                            Text(
                              program,
                              style: TextStyle(
                                  color: Color.fromRGBO(60, 71, 92, 1),
                                  fontSize: 12,
                                  letterSpacing: 0.3,
                                  fontFamily: 'Montserrat'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _buildNaslov("Galerija"),
                            PhotoGallery(imageList: imageList),
                            SizedBox(
                              height: 20,
                            ),
                            _buildNaslov("Prikaži na mapi"),
                            _buildMap(lokacija),
                            SizedBox(
                              height: 20,
                            ),
                            _buildNaslov("Komentari"),
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
                                  onPressed: () {},
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
                          Navigator.of(context).pop();
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
    if (commentList == null || commentList.isEmpty) {
      return Center(
        child: Text('No comments available'),
      );
    }

    return Column(
      children: commentList.map((comment) {
        return CommentWidget(
          username: comment['username'] ?? 'Unknown user',
          text: comment['text'] ?? 'No text',
        );
      }).toList(),
    );
  }
}

Widget _buildMap(String lokacija) {
  return FutureBuilder(
    future: locationFromAddress(lokacija),
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Could not load map');
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
