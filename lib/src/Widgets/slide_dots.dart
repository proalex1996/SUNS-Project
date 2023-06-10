import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SlideDots extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  bool isActive;
  SlideDots(this.isActive, this.height, this.width, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 7,
      height: height ?? 7,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3.0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
