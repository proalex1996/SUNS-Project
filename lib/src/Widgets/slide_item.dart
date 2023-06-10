import 'package:flutter/material.dart';

import '../model/slide.dart';

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                slideList[index].imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 10, left: 20),
              child: Text(
                slideList[index].title,
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 32,
                    color: Color(0xFF444566),
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 13, right: 26, left: 28),
              child: Text(
                slideList[index].description,
                style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
