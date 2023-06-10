import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class ExampleAppBarLayout extends StatelessWidget {
  const ExampleAppBarLayout({
    Key key,
    @required this.title,
    this.showGoBack,
    this.child,
  }) : super(key: key);

  final String title;
  final bool showGoBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        centerTitle: true,
        title: Text(
          'Toa thuốc',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: child,
      ),
    );
  }
}
