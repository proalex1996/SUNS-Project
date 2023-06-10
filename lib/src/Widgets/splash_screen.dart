import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Image.asset(
          "assets/splash_screen/splash.png",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            "assets/splash_screen/launch_image.png",
            width: MediaQuery.of(context).size.width * 0.7,
            //height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
        ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.3,
        // ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            "assets/splash_screen/gif_file.gif",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.015,
            fit: BoxFit.cover,
          ),
        )
      ],
    ));
  }
}
