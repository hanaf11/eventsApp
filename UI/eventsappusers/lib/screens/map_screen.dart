import 'dart:ffi';

import 'package:flutter/material.dart';

import '../widgets/master_screen.dart';

import 'package:latlong2/latlong.dart';
import 'package:latlong2/spline.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  double latitude = 50;
  double longitude = 50;
  late LatLng initialCenter = LatLng(latitude, longitude);
  Key mapKey = UniqueKey();
  _MapScreenState();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  extractLatitudeLongitude(String output) {
    String latitudeKey = 'Latitude: ';
    String longitudeKey = 'Longitude: ';

    int latitudeStartIndex = output.indexOf(latitudeKey) + latitudeKey.length;
    int longitudeStartIndex =
        output.indexOf(longitudeKey) + longitudeKey.length;

    int latitudeEndIndex = output.indexOf(',', latitudeStartIndex);
    int longitudeEndIndex = output.indexOf(',', longitudeStartIndex);

    String lat = output.substring(latitudeStartIndex, latitudeEndIndex).trim();
    String long =
        output.substring(longitudeStartIndex, longitudeEndIndex).trim();

    return LatLng(double.parse(lat), double.parse(long));
  }

  _search() {
    locationFromAddress(_searchController.text).then((locations) {
      var output = 'No results found.';
      if (locations.isNotEmpty) {
        output = locations[0].toString();
        _refreshMap(output);
      }
    });
  }

  _refreshMap(String output) {
    LatLng newCenter = extractLatitudeLongitude(output);
    setState(() {
      mapKey = UniqueKey();
      initialCenter = newCenter;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    return MasterScreen(
        selectedIndex: 1,
        showBackButton: true,
        child: Expanded(
            child: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      _buildSearch(),
                      SizedBox(
                        height: 15,
                      ),
                      _buildMap(initialCenter)
                    ],
                  )));
  }

  _buildSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(4, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _searchController,
                  decoration:
                      new InputDecoration.collapsed(hintText: 'Naziv događaja'),
                ),
              )),
              Container(
                  child: IconButton(
                onPressed: () {
                  _search();
                },
                icon: const Icon(Icons.search),
                iconSize: 25,
                color: Colors.black,
                splashRadius: 10,
              ))
            ],
          )),
    );
  }

  _buildMap(initialCenter) {
    print('initialCenter: $initialCenter,');

    return Expanded(
        child: Stack(children: [
      FlutterMap(
          key: mapKey,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(
              markers: [
                Marker(
                    point: initialCenter,
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.location_pin,
                      size: 60,
                      color: Color.fromRGBO(227, 48, 71, 1),
                    )),
              ],
            ),
          ]),
      /*Positioned(
        top: 10,
        right: 10,
        child: FloatingActionButton(
          onPressed: _refreshMap,
          child: Icon(Icons.refresh),
        ),
      ),*/
    ]));
  }
}
