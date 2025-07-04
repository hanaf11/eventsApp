import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class Authorization {
  static String? username;
  static String? password;
}

String formErrorMessage(dynamic jsonResponse) {
  var errors = jsonResponse['errors'];
  return errors.entries
      .map((entry) {
        String fieldName = entry.key;
        List<dynamic> fieldErrors = entry.value;
        return fieldErrors.join(', ');
      })
      .join('; ')
      .toString();
}

class ImageObj {
  Image image;
  String base64Image;

  ImageObj(this.image, this.base64Image);
}

Future<LatLng> getLatLong(String lokacija) async {
  try {
    var locations = await locationFromAddress(lokacija);
    if (locations.isNotEmpty) {
      double lat = locations[0].latitude;
      double long = locations[0].longitude;
      print(lat);
      print(long);
      return LatLng(lat, long);
    } else {
      return LatLng(0, 0);
    }
  } on Exception catch (e) {
    print("Exception: $e");
    print("Nije moguće pronaći traženu lokaciju, unesite validnu adresu");
    return const LatLng(0, 0);
  }
}
