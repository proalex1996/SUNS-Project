import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/src/account/notification/notification_screen.dart';
import 'package:suns_med/src/account/updateinformation_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBackButton, hasAcctionIcon;
  final bool isPurpleAppBar, isOrangeAppBar, isSmallOrangeAppBar, isTopPadding;
  final String title;
  final double titleSize, topPadding;
  final Widget actionIcon;
  final Function() onActionTap;

  const CustomAppBar({
    Key key,
    this.hasAcctionIcon = false,
    this.hasBackButton = true,
    @required this.title,
    this.titleSize = 18,
    this.isTopPadding = true,
    this.topPadding = 30,
    this.isPurpleAppBar = false,
    this.isOrangeAppBar = false,
    this.isSmallOrangeAppBar = false,
    this.actionIcon,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: (hasBackButton)
          ? GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  padding:
                      (isTopPadding) ? EdgeInsets.only(top: topPadding) : null,
                  child: Icon(Icons.arrow_back)),
            )
          : Container(),
      actions: [
        (hasAcctionIcon)
            ? GestureDetector(
                onTap: onActionTap,
                child: Container(
                    padding: (isTopPadding)
                        ? EdgeInsets.only(top: topPadding, right: 20)
                        : EdgeInsets.only(right: 20),
                    child: actionIcon),
              )
            : Container(),
      ],
      backgroundColor: AppColor.deepBlue,
      title: Container(
        padding:
            (isTopPadding) ? EdgeInsets.only(top: topPadding, right: 20) : null,
        child: Text(
          title,
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              color: Colors.white,
              fontSize: titleSize),
        ),
      ),
      flexibleSpace: Container(
        height: (isSmallOrangeAppBar)
            ? 85
            : (isOrangeAppBar)
                ? 140
                : (isPurpleAppBar)
                    ? 160
                    : 85,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: (isSmallOrangeAppBar)
                  ? AssetImage(
                      "assets/images/small-appbar.png",
                    )
                  : (isOrangeAppBar)
                      ? AssetImage(
                          "assets/images/orange-appbar.png",
                        )
                      : (isPurpleAppBar)
                          ? AssetImage(
                              "assets/images/purple-appbar.png",
                            )
                          : AssetImage(
                              "assets/images/small-appbar.png",
                            ),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TopAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TopAppBar({Key key}) : super(key: key);

  // final Icon actionIcon;
  // final Function() onActionTap;

  @override
  _TopAppBarState createState() => _TopAppBarState();

  // @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopAppBarState extends State<TopAppBar> {
  final blocSession = SessionBloc();
  final notifyBloc = NotificationBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.white,
      leading: SizedBox(),
      flexibleSpace: BlocProvider<EventSession, StateSession, SessionBloc>(
          bloc: blocSession,
          builder: (state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 10, bottom: 5),
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      'assets/images/profile/logo_gcare.png',
                      height: 55,
                      width: 95,
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      miniAvatar(state.user?.avatar),
                      SizedBox(
                        width: width(context) * 0.02,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).hello,
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: AppColor.darkPurple,
                              fontSize: 14,
                            ),
                          ),
                          Text('${state.user?.fullName}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: AppColor.darkPurple,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        width: width(context) * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => NotificationScreen(),
                            ),
                          );
                        },
                        child: Stack(children: <Widget>[
                          new Icon(
                            Icons.notifications_outlined,
                            color: AppColor.darkPurple,
                            size: 30,
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: BlocProvider<NotificationEvent,
                                NotificationState, NotificationBloc>(
                              bloc: notifyBloc,
                              // navigator: (current) => //setState(() {
                              //     notifyBloc.dispatch(CountNotifyEvent()),
                              // //}),
                              builder: (state) {
                                return state.countNotify == null ||
                                        state.countNotify == 0
                                    ? Container()
                                    : CircleAvatar(
                                        maxRadius: 8,
                                        backgroundColor: AppColor.deepBlue,
                                        child: Text(
                                          state.countNotify > 99
                                              ? "99+"
                                              : "${state?.countNotify}",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize: 8,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                              },
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: width(context) * 0.05,
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
