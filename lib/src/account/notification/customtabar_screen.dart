import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/account/notification/chat/chat_screen.dart';
import 'package:suns_med/src/account/notification/general/general_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomTabbarScreen extends StatefulWidget {
  const CustomTabbarScreen({Key key}) : super(key: key);

  @override
  _CustomTabbarScreenState createState() => _CustomTabbarScreenState();
}

class _CustomTabbarScreenState extends State<CustomTabbarScreen> {
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      // initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: AppColor.veryLightPinkFour,
            bottom: TabBar(
              indicatorColor: AppColor.darkPurple,
              labelColor: AppColor.darkPurple,
              unselectedLabelColor: AppColor.warmGrey,
              tabs: [
                Tab(
                  child: Text(
                    language.general,
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Chat',
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          // physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            GeneralScreen(),
            ChatScreen(),
          ],
        ),
      ),
    );
  }
}
