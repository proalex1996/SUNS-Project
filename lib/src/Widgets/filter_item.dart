import 'package:flutter/material.dart';

class FilterITem extends StatelessWidget {
  final String title;
  final String image;
  final Function() function;
  final Color color;
  FilterITem({this.title, this.image, this.function, this.color});
  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: function,
            child: Container(
              decoration:
                  BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
              padding: useMobileLayout
                  ? const EdgeInsets.all(6)
                  : const EdgeInsets.all(9),
              child: Container(
                width: useMobileLayout ? 60 : 75,
                height: useMobileLayout ? 60 : 75,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Image.asset(
                  image,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.22,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  // fontFamily: 'Montserrat-M',
                  fontStyle: FontStyle.normal,
                  fontSize: useMobileLayout ? 15 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
