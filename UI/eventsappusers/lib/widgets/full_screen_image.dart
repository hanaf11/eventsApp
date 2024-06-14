import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String? imagePath;
  final Image? image;
  final String tag;

  FullScreenImage({super.key, this.imagePath, this.image, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Hero(
            tag: tag,
            child: image != null
                ? image!
                : imagePath != null
                    ? Image.asset(
                        imagePath!,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        'assets/images/no_picture.jpg',
                        fit: BoxFit.contain,
                      )),
      ),
      backgroundColor: Colors.black,
    );
  }
}
