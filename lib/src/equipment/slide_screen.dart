import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SlideScreen extends StatefulWidget {
  String images;
  SlideScreen({this.images});
  @override
  _SlideScreenState createState() => _SlideScreenState();
}

class _SlideScreenState extends State<SlideScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 284,
      child: Image.network(widget.images),
    );
  }
}
