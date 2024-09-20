import 'package:flutter/material.dart';

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
        return "$fieldName: ${fieldErrors.join(', ')}";
      })
      .join('; ')
      .toString();
}

class ImageObj {
  Image image;
  String base64Image;

  ImageObj(this.image, this.base64Image);
}
