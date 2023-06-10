import 'package:flutter/material.dart';
import 'package:suns_med/is-app-sunsclinc.dart';
import 'package:suns_med/shared/provider/app_config_provider.dart';
import 'package:suns_med/src/app.dart';
import 'flavors.dart';

void main() {
  F.appFlavor = Flavor.UAT;
  IsAppSunsClinic.isAppClinic = true;
  runApp(
    AppConfigProvider(
      child: MyApp(),
      production: false,
      messengerBaseUrl: "http://uat-sunsdemo-enduser.sunsoftware.vn",
      oneSignalAppId: "23313234-fb4d-434a-b3b2-525ed8750d42",
      remoteServiceBaseUrl: "http://uat-sunsdemo-login.sunsoftware.vn",
      managementBaseUrl: "http://uat-management.sunsoftware.vn",
      logBaseUrl: "http://uat-doctorcheck-payment.sunsoftware.vn",
      managementBaseUrlNew: "http://uat-sunsdemo-enduser.sunsoftware.vn/",
    ),
  );
}
