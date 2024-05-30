import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Hero(
          tag: 'bannerImage',
          child: Image.asset(
            'assets/images/banner.jpg',
            fit: BoxFit.contain,
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
