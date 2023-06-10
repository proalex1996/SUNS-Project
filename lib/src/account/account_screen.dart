import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/account/changepassword_screen.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/src/account/favoritenews_screen.dart';
import 'package:suns_med/src/account/notification/notification_screen.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';
import 'package:suns_med/src/account/session_service_user_background_image_bloc.dart';
import 'package:suns_med/src/account/session_usagepolicy_bloc.dart';
import 'package:suns_med/src/account/updateinformation_screen.dart';
import 'package:suns_med/src/medicine/order_medicines.dart';
import 'package:suns_med/src/signup_signin/login/login_screen.dart';
import 'medicalrecord/medicalrecord_screen.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:suns_med/src/account/webview_policy.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final notifyBloc = NotificationBloc();
  final bloc = PolicyBloc();
  final blocSession = SessionBloc();
  final commonBloc = UserBackgroundBloc();
  String _version;

  @override
  void initState() {
    imageCache.clearLiveImages();
    imageCache.clear();
    bloc.dispatch(EventGetData());
    notifyBloc.dispatch(CountNotifyEvent());
    commonBloc.dispatch(EventLoadBackground());
    if (_version == null) _getVersion();
    super.initState();
  }

  Future<void> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo?.version;
  }

  Future<Null> _refreshHome() async {
    // await Future.wait([
    //   Future.delayed(const Duration(microseconds: 100), () {
    //     imageCache.clearLiveImages();
    //     imageCache.clear();
    //   })
    // ]);
    // Future.delayed(const Duration(microseconds: 500), () {
    notifyBloc.dispatch(CountNotifyEvent());
    //   commonBloc.dispatch(EventLoadBackground());
    // });

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.whitethree,
      appBar: const TopAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: SingleChildScrollView(
          child: Container(
            width: width(context),
            // height: height(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.white,
                  Colors.white38,
                  Color(0xFFF2F8FF)
                ],
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocProvider<EventSession, StateSession, SessionBloc>(
                        bloc: blocSession,
                        builder: (state) {
                          return imgBackgroud(
                              context, state.user?.fullName, false);
                        }),
                    SizedBox(
                      height: 70,
                    ),
                    buildRowContent('ic_user2', language.personalInformation,
                        UpdateInformationScreen(), null, null),
                    SizedBox(
                      height: 20,
                    ),
                    // buildRowContent('notifications', language.notification,
                    //     NotificationScreen(), _buildCircleNotifi(), null),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    buildRowContent('ic_favorited_news', language.favoriteNew,
                        FavoriteNewsScreen(), null, null),
                    SizedBox(
                      height: 20,
                    ),
                    buildRowContent('ic_list_file', language.listRecords,
                        MedicalRecordScreen(), null, null),
                    SizedBox(
                      height: 20,
                    ),
                    buildRowContent(
                        'ic_change_password',
                        language.changePassword,
                        ChangePasswordScreen(),
                        null,
                        null),
                    SizedBox(
                      height: 20,
                    ),
                    buildRowContent('ic_my_order', language.myOrders,
                        OrderMedicine(), null, null),
                    SizedBox(
                      height: 20,
                    ),
                    buildRowContent(
                      'ic_logout',
                      language.logout,
                      ChangePasswordScreen(),
                      null,
                      () => showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          content: Text(
                            language.sureLogout,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                color: Colors.black,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .fontSize),
                          ),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                SessionBloc().stream.listen((event) {
                                  if (event.isAuthentication != true) {
                                    // contactBloc
                                    //     .dispatch(ResetStateContactEvent());
                                    // appointmentBloc
                                    //     .dispatch(ResetStateAppointmentEvent());
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginScreen()),
                                      ModalRoute.withName('/'),
                                    );
                                  }
                                });

                                SessionBloc().dispatch(EventLogoutSession());
                              },
                              child: Text(language.accept,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      color: AppColor.deepBlue)),
                            ),
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(language.close,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      color: AppColor.deepBlue)),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    buildRowContent(
                        'policy',
                        'Chính sách sử dụng',
                        WebViewUrlPolicy(
                          url: bloc?.state?.data,
                        ),
                        null,
                        null),
                    SizedBox(
                      height: 30,
                    ),
                    // _buildRowContent(
                    //   'assets/images/logout.png',
                    //   'Đăng xuất',
                    //   () => showCupertinoDialog(
                    //     context: context,
                    //     builder: (context) => CupertinoAlertDialog(
                    //       content: Text(
                    //         "Bạn có chắc chắn muốn đăng xuất?",
                    //         textAlign: TextAlign.center,
                    //         style:TextStyle(
                    ///       fontFamily: 'Montserrat-M',
                    //             color: Colors.black,
                    //             fontSize: Theme.of(context)
                    //                 .textTheme
                    //                 .headline6
                    //                 .fontSize),
                    //       ),
                    //       actions: [
                    //         CupertinoDialogAction(
                    //           onPressed: () {
                    //             SessionBloc().stream.listen((event) {
                    //               if (event.isAuthentication != true) {
                    //                 // contactBloc
                    //                 //     .dispatch(ResetStateContactEvent());
                    //                 // appointmentBloc
                    //                 //     .dispatch(ResetStateAppointmentEvent());
                    //                 Navigator.pushAndRemoveUntil(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (BuildContext context) =>
                    //                           LoginScreen()),
                    //                   ModalRoute.withName('/'),
                    //                 );
                    //               }
                    //             });

                    //             SessionBloc().dispatch(EventLogoutSession());
                    //           },
                    //           child: Text("Đồng ý",
                    //               style:TextStyle(
                    //       fontFamily: 'Montserrat-M',color: AppColor.deepBlue)),
                    //         ),
                    //         CupertinoDialogAction(
                    //           onPressed: () {
                    //             Navigator.of(context).pop();
                    //           },
                    //           child: Text("Đóng",
                    //               style:TextStyle(
                    //           fontFamily: 'Montserrat-M',color: AppColor.deepBlue)),
                    //         )
                    //       ],
                    //     ),

                    //   ),
                    // ),
                    _buildTextVersion(),

                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 12),
                      margin: EdgeInsets.fromLTRB(
                          width(context) * 0.05, 0, width(context) * 0.05, 0),
                      child: Text(
                        "Phát triển bởi SUNS Software JSC",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 16,
                            color: AppColor.veryLightPinkTwo),
                      ),
                    ),
                    // _buildTextVersion(),
                  ],
                ),
                BlocProvider<EventSession, StateSession, SessionBloc>(
                    bloc: blocSession,
                    builder: (state) {
                      return Positioned(
                        top: height(context) * 0.12,
                        left: width(context) * 0.38,
                        child: buildToolAddImage(state.user?.avatar),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTextVersion() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: EdgeInsets.fromLTRB(
          width(context) * 0.05, 0, width(context) * 0.05, 0),
      child: Text(
        (_version != null) ? 'Version: $_version' : 'Unknown',
        style: TextStyle(
            fontFamily: 'Montserrat-M',
            fontSize: 16,
            color: AppColor.veryLightPinkTwo),
      ),
    );
  }

  _buildCircleNotifi() {
    return BlocProvider<NotificationEvent, NotificationState, NotificationBloc>(
      bloc: notifyBloc,
      builder: (state) {
        return state.countNotify == null || state.countNotify == 0
            ? Container()
            : CircleAvatar(
                maxRadius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  state.countNotify > 99 ? "99+" : "${state?.countNotify}",
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 10,
                      color: Colors.white),
                ),
              );
      },
    );
  }

  // _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   }
  // }

  _buildRowContent(String image, String text, Function _onTap) {
    return BlocProvider<NotificationEvent, NotificationState, NotificationBloc>(
        bloc: notifyBloc,
        builder: (state) {
          return state.countNotify == null
              ? Shimmer.fromColors(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 16, top: 18.3, right: 16, bottom: 19),
                    margin: EdgeInsets.only(top: 15.3),
                    color: AppColor.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              image,
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(
                              width: 22.3,
                            ),
                            Text(
                              text,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M', fontSize: 16),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  baseColor: AppColor.paleGreyFour,
                  highlightColor: AppColor.whitetwo,
                )
              : GestureDetector(
                  onTap: _onTap,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 16, top: 18.3, right: 16, bottom: 19),
                    margin: EdgeInsets.only(top: 15.3),
                    color: AppColor.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              image,
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(
                              width: 22.3,
                            ),
                            Text(
                              text,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M', fontSize: 16),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                );
        });
  }

  buildRowContent(String image, String title, Widget widget, Widget extraWidget,
      Function function) {
    return BlocProvider<NotificationEvent, NotificationState, NotificationBloc>(
        bloc: notifyBloc,
        builder: (state) {
          return GestureDetector(
            onTap: function == null
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget,
                      ),
                    );
                  }
                : function,
            child: extraWidget == null
                ? Container(
                    margin: EdgeInsets.fromLTRB(
                        width(context) * 0.05, 0, width(context) * 0.05, 0),
                    height: height(context) * 0.08,
                    width: width(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: width(context) * 0.05),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/accounts/$image.png',
                                width: 25,
                                height: 25,
                              ),
                              SizedBox(
                                width: width(context) * 0.05,
                              ),
                              Text(
                                title,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: AppColor.darkPurple),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: width(context) * 0.05),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ),
                      ],
                    ))
                : Container(
                    margin: EdgeInsets.fromLTRB(
                        width(context) * 0.05, 0, width(context) * 0.05, 0),
                    height: height(context) * 0.08,
                    width: width(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: width(context) * 0.05),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/$image.png',
                                width: 25,
                                height: 25,
                              ),
                              SizedBox(
                                width: width(context) * 0.05,
                              ),
                              Text(
                                title,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: AppColor.darkPurple),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: width(context) * 0.05),
                          child: Row(
                            children: [
                              extraWidget,
                              SizedBox(
                                width: width(context) * 0.05,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
          );
        });
  }
}
