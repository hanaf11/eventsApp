import 'package:flutter/material.dart';

class FullScreenGallery extends StatefulWidget {
  final List<String>? imagePathList;
  final List<Image>? imageList;
  final int initialIndex;

  FullScreenGallery(
      {this.imagePathList, this.imageList, required this.initialIndex});

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
    var length = widget.imageList != null && widget.imageList!.isNotEmpty
        ? widget.imageList!.length
        : widget.imagePathList != null && widget.imagePathList!.isNotEmpty
            ? widget.imagePathList!.length
            : 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: PageView.builder(
          controller: _pageController,
          itemCount: length,
          itemBuilder: (context, index) {
            return Center(
                child: widget.imageList != null && widget.imageList!.isNotEmpty
                    ? Hero(tag: 'image$index', child: widget.imageList![index])
                    : widget.imagePathList != null &&
                            widget.imagePathList!.isNotEmpty
                        ? Hero(
                            tag: 'image$index',
                            child: Image.asset(
                              widget.imagePathList![index],
                              fit: BoxFit.contain,
                            ))
                        : Container());
          }),
      backgroundColor: Colors.black,
    );
  }
}
