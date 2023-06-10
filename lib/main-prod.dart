import 'package:flutter/material.dart';
import 'package:suns_med/shared/provider/app_config_provider.dart';
import 'package:suns_med/src/app.dart';
import 'flavors.dart';
import 'is-app-sunsclinc.dart';

void main() {
  F.appFlavor = Flavor.PROD;
  IsAppSunsClinic.isAppClinic = true;
  runApp(
    AppConfigProvider(
      child: MyApp(),
      production: true,
      messengerBaseUrl: "http://gcare-enduser.sunsoftware.vn",
      oneSignalAppId: "a162e28c-eb3e-4bf0-8250-7e612f45d084",
      remoteServiceBaseUrl: "http://gcare-login.sunsoftware.vn",
      managementBaseUrl: "http://gcare-management.sunsoftware.vn",
      logBaseUrl: "http://gcare-payment.sunsoftware.vn",
      managementBaseUrlNew: "http://gcare-enduser.sunsoftware.vn/",
    ),
  );
}
