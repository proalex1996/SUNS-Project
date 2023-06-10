import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/shared/app_config.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/doctor_popular_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';

class AppConfigProvider extends InheritedWidget {
  final String oneSignalAppId;
  final bool production;
  final String remoteServiceBaseUrl;
  final ProvinceModel provinceModel;
  final DoctorPopularModel doctorModel;
  final String managementBaseUrl;
  final String logBaseUrl;
  final String managementBaseUrlNew;
  final String messengerBaseUrl;
  AppConfigProvider({
    Key key,
    @required Widget child,
    this.production,
    this.doctorModel,
    this.provinceModel,
    @required this.oneSignalAppId,
    @required this.managementBaseUrl,
    @required this.remoteServiceBaseUrl,
    @required this.logBaseUrl,
    @required this.managementBaseUrlNew,
    @required this.messengerBaseUrl,
  })  : assert(child != null),
        super(key: key, child: child) {
    _errorFilter();
    // navigatorKey.currentState.overlay.context
    AppConfig().managementBaseUrl = managementBaseUrl;
    AppConfig().remoteServiceBaseUrl = remoteServiceBaseUrl;
    AppConfig().logBaseUrl = logBaseUrl;
    AppConfig().production = this.production;
    AppConfig().managementBaseUrlNew = managementBaseUrlNew;
    AppConfig().oneSignalAppId = oneSignalAppId;
    AppConfig().messengerBaseUrl = messengerBaseUrl;
  }
  _errorFilter() {
    if (production) {
      //Todo update error page and log
      ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
        return Scaffold(
          body: Center(
            child: Text(
              "Lỗi ứng dụng!",
            ),
          ),
        );
      };
    }
  }

  static AppConfigProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfigProvider>();
  }

  @override
  bool updateShouldNotify(AppConfigProvider old) {
    return remoteServiceBaseUrl != old.remoteServiceBaseUrl ||
        managementBaseUrl != old.managementBaseUrl ||
        logBaseUrl != old.logBaseUrl ||
        managementBaseUrlNew != old.managementBaseUrlNew ||
        production != old.production;
  }
}
