import 'package:flutter/material.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'order_medicines.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/home/home_screen.dart';
import 'package:suns_med/src/Widgets/Bottombar/navigator_bar.dart';

class CompletedMedicine extends StatefulWidget {
  CompletedMedicine({Key key}) : super(key: key);

  @override
  _CompletedMedicine createState() => _CompletedMedicine();
}

class _CompletedMedicine extends State<CompletedMedicine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: bodyBuilding());
  }

  Widget bodyBuilding() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/profile/br_completed.png"),
          fit: BoxFit.cover,
        ),
      ),
      height: height(context),
      width: width(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, height(context) * 0.2, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/profile/check_circle.png",
              fit: BoxFit.scaleDown,
            ),
            Text(
              AppLocalizations.of(context).orderSuccessful,
              overflow: TextOverflow.fade,
              maxLines: 2,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 16,
                  color: AppColor.darkPurple,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: height(context) * 0.04,
            ),
            Text(
              AppLocalizations.of(context).thank,
              overflow: TextOverflow.fade,
              maxLines: 2,
              style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 14,
                color: AppColor.darkPurple,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: height(context) * 0.04,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => BottomBar(
                              index: 0,
                            )),
                    (Route<dynamic> route) => false);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomeScreen()),
                // );
              },
              child: Container(
                height: height(context) * 0.08,
                width: width(context) * 0.9,
                decoration: BoxDecoration(
                  color: Color(0xFF616C9A),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).backHome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
