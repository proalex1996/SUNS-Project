import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/Widgets/slide_dots.dart';
import 'package:suns_med/src/Widgets/slide_item.dart';
import 'package:suns_med/src/model/slide.dart';
import 'package:suns_med/src/signup_signin/login/login_screen.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final slideList = [
      Slide(
        imageUrl: 'assets/images/imgStartedScr.png',
        title: AppLocalizations.of(context).titleStart1,
        description: AppLocalizations.of(context).descriptStart1,
      ),
      Slide(
        imageUrl: 'assets/images/imgStartedScr2.png',
        title: AppLocalizations.of(context).titleStart2,
        description: AppLocalizations.of(context).descriptStart2,
      ),
      Slide(
        imageUrl: 'assets/images/imgStartedScr3.png',
        title: AppLocalizations.of(context).titleStart3,
        description: AppLocalizations.of(context).descriptStart2,
      ),
    ];
    return Scaffold(
      body: Container(
        color: Color(0xffEBEBEB),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: slideList.length,
                itemBuilder: (ctx, i) => SlideItem(i),
              ),
            ),
            (_currentPage != 2)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(
                            left: 29, bottom: 55, top: 44),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            for (int i = 0; i < slideList.length; i++)
                              if (i == _currentPage)
                                SlideDots(true, 18, 18, AppColor.deepBlue)
                              else
                                SlideDots(false, 18, 18, AppColor.greyColor)
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Text(
                              'Bỏ qua',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: AppColor.deepBlue,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      // if (_currentPage == 2)
                      //   Container(
                      //     alignment: Alignment.bottomRight,
                      //     child: IconButton(
                      //       onPressed: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => LoginScreen()));
                      //       },
                      //       icon: Icon(Icons.arrow_forward_ios),
                      //     ),
                      //   )
                      // else
                      //   Container()
                    ],
                  )
                : Container(
                    padding: EdgeInsets.only(bottom: 20),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      color: AppColor.purple,
                      radius: BorderRadius.circular(26),
                      text: 'Bắt đầu',
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
