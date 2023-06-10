import 'dart:convert';

import 'package:flutter/widgets.dart';

class GalleryExampleItem {
  final String id;
  final String resource;
  final bool isSvg;
  GalleryExampleItem({this.id, this.resource, this.isSvg = false});
}

class GalleryExampleItemThumbnail extends StatelessWidget {
  const GalleryExampleItemThumbnail(
      {Key key, this.galleryExampleItem, this.onTap, this.img})
      : super(key: key);

  final GalleryExampleItem galleryExampleItem;

  final GestureTapCallback onTap;

  List<String> imageFromJson(String str) =>
      List<String>.from(json.decode(str).map((x) => x));

  String imageToJson(List<String> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x)));

  final String img;

  @override
  Widget build(BuildContext context) {
    var images = imageFromJson(img);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        // child: Hero(
        //   tag: galleryExampleItem.id,
        //   child: Image.asset(galleryExampleItem.resource, height: 80.0),
        // ),
        child: Wrap(
          children: List.generate(images.length, (index) {
            return Image.network(images[index]);
          }),
        ),
      ),
    );
  }
}

List<GalleryExampleItem> galleryItems = <GalleryExampleItem>[
  GalleryExampleItem(
    id: "tag1",
    resource: "assets/images/prescription1.png",
  ),
  GalleryExampleItem(id: "tag2", resource: "assets/images/prescription2.png"),
  GalleryExampleItem(
    id: "tag3",
    resource: "assets/images/prescription1.png",
  ),
];
