import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/account/account_screen.dart';
import 'package:suns_med/src/appointment/tabbar-state-appointment.dart';
import 'package:suns_med/src/contacts/listcontacts_screen.dart';
import 'package:suns_med/src/home/home_screen.dart';
import 'package:suns_med/src/news/news_screen.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  final String username;
  int index;
  BottomBar({this.username, this.index = 0});
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  // static final List<Widget> listScreen = [
  //   HomeScreen(),
  //   TabbarStateAppointment(),
  //   ListContactsScreen(),
  //   NewsScreen(),
  //   AccountScreen(),
  // ];
  final notifyBloc = NotificationBloc();
  @override
  void initState() {
    // widget.index = widget?.index;

    notifyBloc.dispatch(CountNotifyEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        body: IndexedStack(
          index: widget?.index,
          children: [
            HomeScreen(),
            TabbarStateAppointment(),
            ListContactsScreen(),
            NewsScreen(),
            AccountScreen(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar: new Theme(
        //   data: Theme.of(context).copyWith(
        //     primaryColor: AppColor.deepBlue,
        //     textTheme: Theme.of(context).textTheme.copyWith(
        //           caption: newTextStyle(
        //        fontFamily: 'Montserrat-M',color: AppColor.greyBlue),
        //         ),
        //   ),

        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.095,
            margin: EdgeInsets.only(right: 16, left: 16, bottom: 20),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                selectedItemColor: AppColor.white,
                // unselectedItemColor: AppColor.greyBlue[400],

                selectedFontSize: 8,
                unselectedFontSize: 8,
                onTap: (index) {
                  setState(() {
                    widget?.index = index;
                  });
                },
                currentIndex: widget?.index,
                type: BottomNavigationBarType.fixed,
                // iconSize: 28,
                items: [
                  BottomNavigationBarItem(
                    icon: Material(
                      elevation: widget?.index != 0 ? 0 : 8,
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                      shadowColor: AppColor.orangeColor,
                      color: Colors.white,
                      child: Container(
                          padding: EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget?.index == 0
                                ? AppColor.lightOrange
                                : Colors.transparent,
                          ),
                          child: Image.asset(
                            'assets/imgclinic/ic_home.png',
                            width: 20,
                            height: 20,
                            color: widget?.index != 0
                                ? AppColor.greyBlue
                                : Colors.white,
                          )),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Material(
                        elevation: widget?.index != 1 ? 0 : 8,
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                        shadowColor: AppColor.orangeColor,
                        color: Colors.white,
                        child: Container(
                            padding: EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget?.index == 1
                                  ? AppColor.lightOrange
                                  : Colors.transparent,
                            ),
                            child: Image.asset(
                              'assets/imgclinic/ic_lich.png',
                              width: 20,
                              height: 20,
                              color: widget?.index == 1
                                  ? Colors.white
                                  : AppColor.greyBlue,
                            ))),
                    label: 'Lịch hẹn',
                  ),
                  BottomNavigationBarItem(
                    icon: Material(
                        elevation: widget?.index != 2 ? 0 : 8,
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                        shadowColor: AppColor.orangeColor,
                        color: Colors.white,
                        child: Container(
                            padding: EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget?.index == 2
                                  ? AppColor.lightOrange
                                  : Colors.transparent,
                            ),
                            child: Image.asset(
                              'assets/imgclinic/ic_hoso.png',
                              width: 20,
                              height: 20,
                              color: widget?.index == 2
                                  ? Colors.white
                                  : AppColor.greyBlue,
                            ))),
                    label: 'Hồ sơ',
                  ),
                  BottomNavigationBarItem(
                    icon: Material(
                        elevation: widget?.index != 3 ? 0 : 8,
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                        shadowColor: AppColor.orangeColor,
                        color: Colors.white,
                        child: Container(
                            padding: EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget?.index == 3
                                  ? AppColor.lightOrange
                                  : Colors.transparent,
                            ),
                            child: Image.asset(
                              'assets/imgclinic/ic_tintuc.png',
                              width: 20,
                              height: 20,
                              color: widget?.index == 3
                                  ? Colors.white
                                  : AppColor.greyBlue,
                            ))),
                    label: 'Bài viết',
                  ),
                  BottomNavigationBarItem(
                    icon: Material(
                        elevation: widget?.index != 4 ? 0 : 8,
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                        shadowColor: AppColor.orangeColor,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget?.index == 4
                                ? AppColor.lightOrange
                                : Colors.transparent,
                          ),
                          child: Image.asset(
                            'assets/imgclinic/ic_user.png',
                            width: 20,
                            height: 20,
                            color: widget?.index == 4
                                ? Colors.white
                                : AppColor.greyBlue,
                          ),
                        )),
                    label: 'Tài khoản',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
