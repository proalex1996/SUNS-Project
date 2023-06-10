import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/appointment/appointment_screen.dart';
import 'package:suns_med/src/product/service-package-list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';

class TabbarStateAppointment extends StatefulWidget {
  @override
  _TabbarStateAppointmentState createState() => _TabbarStateAppointmentState();
}

class _TabbarStateAppointmentState extends State<TabbarStateAppointment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(),
      body: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(76),
            child: CustomAppBar(
              title: AppLocalizations.of(context).scheduleAppointment,
              titleSize: 20,
              hasBackButton: false,
              isTopPadding: true,
              isSmallOrangeAppBar: true,
              hasAcctionIcon: true,
              actionIcon: Icon(Icons.add_circle_outlined),
              onActionTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServicePackageList(),
                    ));
              },
            ),
          ),
          body: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 50,
                backgroundColor: AppColor.white,
                bottom: TabBar(
                  labelColor: AppColor.darkPurple,
                  unselectedLabelColor: AppColor.warmGrey,
                  indicatorWeight: 4,
                  indicatorColor: AppColor.darkPurple,
                  isScrollable: true,
                  tabs: [
                    Tab(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text(
                        AppLocalizations.of(context).waitingConfirm,
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,

                          // color: AppColor.pumpkin,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                    Tab(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text(
                        AppLocalizations.of(context).confirmed,
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          // color: AppColor.pumpkin,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                    Tab(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text(
                        AppLocalizations.of(context).cancel,
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          // color: AppColor.pumpkin,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ],
                ),
              ),
              body: TabBarView(
                children: List.generate(3, (index) {
                  {
                    return AppointmentScreen(
                      stateNumber: index,
                      // categoryId: item.id,
                    );
                  }
                }),
              ),
            ),
          )),
    );
  }
}
