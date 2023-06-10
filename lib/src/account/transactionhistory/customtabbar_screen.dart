import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/account/transactionhistory/recharge_screen.dart';

import 'medical_screen.dart';

class CustomTabbarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: AppColor.veryLightPinkFour,
            bottom: TabBar(
              indicatorColor: AppColor.pumpkin,
              tabs: [
                Tab(
                  child: Text(
                    'Nạp tiền',
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColor.pumpkin),
                  ),
                ),
                Tab(
                  child: Text(
                    'Khám bệnh',
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColor.pumpkin),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            RechargeScreen(),
            MedicalScreen(),
          ],
        ),
      ),
    );
  }
}
