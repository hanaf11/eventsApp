import 'package:flutter/material.dart';

class FullScreenGallery extends StatefulWidget {
  final List<String> imageList;
  final int initialIndex;

  FullScreenGallery({required this.imageList, required this.initialIndex});

  @override
  _FullScreenGalleryState createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageList.length,
        itemBuilder: (context, index) {
          return Center(
            child: Hero(
              tag: 'image$index',
              child: Image.asset(
                widget.imageList[index],
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
