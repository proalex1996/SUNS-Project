import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class AppConfig {
  bool production;
  String messengerBaseUrl;
  String remoteServiceBaseUrl;
  String managementBaseUrl;
  String logBaseUrl;
  String managementBaseUrlNew;
  String oneSignalAppId;
  String ipBaseUrl;
  Widget loading;
  final navigatorKey = GlobalKey<NavigatorState>();
  static final AppConfig _instance = AppConfig._internal();

  AppConfig._internal() {
    _initLoading();
  }

  factory AppConfig() {
    return _instance;
  }

  void _initLoading() {
    loading = Center(
      child: SizedBox(
        width: 240.0,
        height: 120.0,
        child: Column(
          children: [
            // Shimmer.fromColors(
            //   baseColor: AppColor.deepBlue,
            //   highlightColor: AppColor.orangeColor,
            //   child: Image.asset(
            //     "assets/images/logo.png",
            //     height: 50,
            //     width: 100,
            //   ),
            // ),
            Image.asset(
              "assets/images/logo.png",
              height: 60,
              width: 120,
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                  strokeWidth: 3,
                  backgroundColor: Colors.black12,
                  valueColor: AlwaysStoppedAnimation(AppColor.deepBlue)),
            ),
          ],
        ),
      ),
    );
  }
}
