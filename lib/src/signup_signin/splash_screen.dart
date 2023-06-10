import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // startTimer();
  }

  // startTimer() async {
  //   var duration = Duration(seconds: 2);
  //   return Timer(duration, route);
  // }

  // route() async {
  //   {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var status = prefs.getBool('isLoggedIn') ?? false;
  //     if (status) {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => BottomBar()));
  //     } else {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => StartScreen()));
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // return AnimatedSplashScreen(
    //     duration: 3000,
    //     splash: Image.asset(
    //       'assets/images/logo.png',
    //       width: 150,
    //       height: 150,
    //     ),
    //     nextScreen: null,
    //     splashTransition: SplashTransition.fadeTransition,
    //     // pageTransitionType: PageTransitionType.scale,

    //     backgroundColor: Colors.white);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/backgroundlog.png'),
                  fit: BoxFit.cover)),
        ),
        Center(
            child: Image.asset(
          'assets/images/logo.png',
          width: 150,
          height: 150,
        )),
      ],
    ));
  }
  // Scaffold(
  //       body: Stack(
  //     children: <Widget>[
  //       Container(
  //         decoration: BoxDecoration(
  //             image: DecorationImage(
  //                 image: AssetImage('assets/images/backgroundlog.png'),
  //                 fit: BoxFit.cover)),
  //       ),
  //       Center(
  //           child: Image.asset(
  //         'assets/images/logo.png',
  //         width: 150,
  //         height: 150,
  //       )),
  //     ],
  //   ))
}
