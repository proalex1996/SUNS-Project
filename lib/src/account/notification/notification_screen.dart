import 'package:flutter/material.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/account/notification/customtabar_screen.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notifyBloc = NotificationBloc();

  // @override
  // void initState() {
  //   notifyBloc.dispatch(CountNotifyEvent());
  //   super.initState();
  // }

  @override
  void dispose() {
    notifyBloc.dispatch(CountNotifyEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Scaffold(
      appBar: const TopAppBar(),
      body: Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: height(context) * 0.1,
        //   backgroundColor: AppColor.deepBlue,
        //   flexibleSpace: Padding(
        //     padding: EdgeInsets.fromLTRB(
        //         width(context) * 0.58, height(context) * 0.1, 0, 0),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage(
        //               'assets/images/profile/pattern_part_circle.png'),
        //           fit: BoxFit.none,
        //         ),
        //       ),
        //     ),
        //   ),
        //   title: Text(
        //     language.notification,
        //     style:TextStyle(
        //                          fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
        //   ),
        //   leading: BlocProvider<NotificationEvent, NotificationState,
        //       NotificationBloc>(
        //     bloc: notifyBloc,
        //     builder: (state) {
        //       return IconButton(
        //           icon: Icon(Icons.arrow_back),
        //           onPressed: () {
        //             notifyBloc.dispatch(CountNotifyEvent());
        //             Navigator.pop(context);
        //           });
        //     },
        //   ),
        //   centerTitle: true,
        // ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(76),
          child: CustomAppBar(
            title: language.notification,
            titleSize: 18,
            isTopPadding: true,
          ),
        ),
        body: CustomTabbarScreen(),
      ),
    );
  }
}
