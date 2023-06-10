import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class XRayScreen extends StatefulWidget {
  final String img;
  XRayScreen({this.img});
  @override
  _XRayScreenState createState() => _XRayScreenState();
}

class _XRayScreenState extends State<XRayScreen> {
  bool verticalGallery = false;

  List<String> imageFromJson(String str) =>
      List<String>.from(json.decode(str).map((x) => x));

  String imageToJson(List<String> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x)));

  @override
  Widget build(BuildContext context) {
    var images = imageFromJson(this.widget.img);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        centerTitle: true,
        title: Text(
          'Kết quả hình ảnh',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Wrap(
            // alignment: WrapAlignment.end,
            spacing: 5,
            runSpacing: 5,
            children: List.generate(images?.length ?? 0, (index) {
              return GestureDetector(
                onTap: () {
                  open(context, index, images);
                },
                child: Image.network(
                  images[index],
                  height: MediaQuery.of(context).size.height * 0.125,
                  width: MediaQuery.of(context).size.width * .31625,
                  fit: BoxFit.cover,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void open(BuildContext context, final int index, List<String> img) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: img,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: verticalGallery ? Axis.vertical : Axis.horizontal,
        ),
      ),
    );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        centerTitle: true,
        title: Text(
          'Kết quả hình ảnh',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Toa thuốc ${currentIndex + 1}",
                style: const TextStyle(
                  fontFamily: 'Montserrat-M',
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.galleryItems[index];
    final bool isSvg = false;
    return isSvg
        ? PhotoViewGalleryPageOptions.customChild(
            child: Container(
              width: 300,
              height: 300,
              child: Image.network(
                item,
                height: 200.0,
              ),
            ),
            childSize: const Size(300, 300),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item),
          )
        : PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(item),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item),
          );
  }
}
