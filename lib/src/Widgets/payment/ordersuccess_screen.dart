import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/src/Widgets/Bottombar/navigator_bar.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/common/dimension.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String orderNo;
  final int stateNumber;
  final String appointmentId;

  OrderSuccessScreen({this.orderNo, this.stateNumber, this.appointmentId});
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  final bloc = AppointmentBloc();
  final sessionBloc = SessionBloc();
  @override
  void initState() {
    super.initState();
    configOneSignal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Image.asset(
              'assets/images/background.png',
              width: width(context),
              height: height(context),
              fit: BoxFit.cover,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 120,
                      height: 120,
                      child: Image.asset(
                        'assets/images/donetick.png',
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    height: 42,
                  ),
                  Text(
                    AppLocalizations.of(context).paymentCode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.darkPurple),
                  ),
                  Text(
                    '${widget?.orderNo}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.darkPurple),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 17, bottom: 39),
                    child: Text(
                      AppLocalizations.of(context).thank,
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 14),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 46,
                    padding: const EdgeInsets.only(left: 32, right: 46),
                    child: RaisedButton(
                      color: AppColor.purple,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomBar(
                                      index: 1,
                                    )),
                            (route) => false);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        AppLocalizations.of(context).returnSchedule,
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void configOneSignal() {
    OneSignal.shared.init("621caa1a-58c1-486f-80b4-c522fe3cb3cf");
  }
}
