import 'package:flutter/material.dart';

import 'full_screen_gallery.dart';

class PhotoGallery extends StatelessWidget {
  final List<String> imageList;

  PhotoGallery({required this.imageList});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenGallery(
                      imageList: imageList,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: Container(
                  width: 90,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Hero(
                    tag: 'image$index',
                    child: Image.asset(
                      imageList[index],
                      fit: BoxFit.cover,
                    ),
                  )),
            );
          },
        ));
  }
}
