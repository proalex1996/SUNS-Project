import 'package:flutter/material.dart';
import 'package:suns_med/shared/provider/app_config_provider.dart';
import 'package:suns_med/src/app.dart';
import 'flavors.dart';

void main() {
  F.appFlavor = Flavor.DEV;
  // OneSignal.shared.init("621caa1a-58c1-486f-80b4-c522fe3cb3cf");
  runApp(
    AppConfigProvider(
      child: MyApp(),
      production: false,
      messengerBaseUrl: "http://uat-sunsdemo-enduser.sunsoftware.vn",
      oneSignalAppId: "2586f586-eb92-4891-ac6f-86ae87d62fa3",
      remoteServiceBaseUrl: "http://uat-sunsdemo-login.sunsoftware.vn",
      managementBaseUrl: "http://uat-management.sunsoftware.vn",
      logBaseUrl: "http://uat-doctorcheck-payment.sunsoftware.vn",
      managementBaseUrlNew: "http://uat-sunsdemo-enduser.sunsoftware.vn/",
    ),
  );
}
