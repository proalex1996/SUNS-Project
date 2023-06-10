import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app_config.dart';

class NotificationService {
  VoidCallback callback;
  var debugLabelString;
  var deviceToken;
  var notifyContent;
  NotificationService(
      {this.callback,
      this.debugLabelString,
      this.deviceToken,
      this.notifyContent});

  Future<void> configOneSignal() async {
    // if (F.appFlavor == Flavor.DEV) {
    await OneSignal.shared.init(AppConfig().oneSignalAppId);
    print(AppConfig().oneSignalAppId);

    var status = await OneSignal.shared.getPermissionSubscriptionState();
    deviceToken = status.subscriptionStatus.userId;
    //show content
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      debugLabelString =
          "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      debugLabelString =
          "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      debugLabelString =
          "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
    });

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setNotificationReceivedHandler(
      (notification) {
        // setState(
        //   () {
        notifyContent =
            notification.jsonRepresentation().replaceAll('\\n', '\n');
        // },
        // );
      },
    );
  }
}
