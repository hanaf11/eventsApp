import 'package:eventsappusers/utils/util.dart';
import 'package:flutter/material.dart';

import 'full_screen_gallery.dart';

class PhotoGallery extends StatelessWidget {
  final List<String>? imagePathList;
  final List<ImageObj>? imageList;
  final bool? delete;
  final Function(int)? onDelete;

  const PhotoGallery(
      {super.key, this.imageList, this.imagePathList, this.delete, this.onDelete});

  @override
  Widget build(BuildContext context) {
    var length = imageList != null && imageList!.isNotEmpty
        ? imageList!.length
        : imagePathList != null && imagePathList!.isNotEmpty
            ? imagePathList!.length
            : null;
    var list = imageList != null && imageList!.isNotEmpty
        ? imageList!
        : imagePathList != null && imagePathList!.isNotEmpty
            ? imagePathList!
            : null;

    return length != null && list != null
        ? SizedBox(
            height: delete != null && delete == true ? 120 : 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: length,
              itemBuilder: (context, index) {
                return Column(children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenGallery(
                              imagePathList: imagePathList,
                              imageList: imageList,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Container(
                          width: 90,
                          height: 70,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: imageList != null && imageList!.isNotEmpty
                              ? Hero(
                                  tag: 'image$index',
                                  child: imageList![index].image)
                              : imagePathList != null &&
                                      imagePathList!.isNotEmpty
                                  ? Hero(
                                      tag: 'image$index',
                                      child: Image.asset(
                                        imagePathList![index],
                                        fit: BoxFit.contain,
                                      ))
                                  : Container())),
                  if (delete != null && delete == true)
                    IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
                        iconSize: 15,
                        padding: EdgeInsets.all(0),
                        splashRadius: 5,
                        color: const Color.fromRGBO(54, 112, 232, 1),
                        onPressed: () {
                          //onDelete(index, slika.slikaId);
                          if (onDelete != null) {
                            onDelete!(index);
                          }
                        })
                ]);
              },
            ))
        : Container();
  }
}
