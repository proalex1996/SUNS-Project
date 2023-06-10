import 'dart:convert';
import 'dart:io';
import 'package:suns_med/shared/app_config.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/call/call_workflow.dart';
import 'package:suns_med/shared/chat/chat_hub_connection.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/doctor_check/dto/doctorcheck_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/notification/dto/detail_notification.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/report/dto/user-summary-report-model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/create_devicetoken_input.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/login_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/upload_avatar_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_model.dart';

enum AppStartScreenType { Slide, Primary, Login }

class StateSession {
  bool isAuthentication;
  AppStartScreenType screenType;
  UserModel user;
  DetailNotificationModel detailNotification;
  String accessToken;
  DoctorCheckModel doctorCheck;
  UserSummaryReportModel userSummaryReport;
  StateSession({
    this.isAuthentication,
    this.user,
    this.userSummaryReport,
    this.screenType,
    this.accessToken,
    this.detailNotification,
    this.doctorCheck,
  });
}

abstract class EventSession {}

class EventLoginSession extends EventSession {
  LoginModel loginModel;

  EventLoginSession({
    this.loginModel,
  });
}

class EventLogoutSession extends EventSession {}

class EventAutoLoginSession extends EventSession {}

class EventGetUser extends EventSession {}

class EventLoadDetailNotification extends EventSession {
  String notificationId;
  EventLoadDetailNotification({this.notificationId});
}

class EventUploadAvatar extends EventSession {
  File image;
  EventUploadAvatar({this.image});
}

// class EventLoadDoctorCheck extends EventSession {}

class SessionBloc extends BlocBase<EventSession, StateSession> {
  static final SessionBloc _instance = SessionBloc._internal();
  SessionBloc._internal();

  factory SessionBloc() {
    return _instance;
  }

  UploadAvatarModel _uploadAvatar = new UploadAvatarModel();

  @override
  void initState() {
    this.state = new StateSession();
    super.initState();
  }

  @override
  Future<StateSession> mapEventToState(EventSession event) async {
    if (event is EventLoginSession) {
      await _login(event.loginModel);
    } else if (event is EventLogoutSession) {
      await _logout();
    } else if (event is EventAutoLoginSession) {
      await _autoLogin();
    } else if (event is EventGetUser) {
      var report = _getUserSummaryReport();
      var user = _getUser();
      await Future.wait([report, user]);
    } else if (event is EventUploadAvatar) {
      await uploadAvatar(event.image);
      // await _getUser();
    } else if (event is EventLoadDetailNotification) {
      await _getDetailNotification(event.notificationId);
    }

    return this.state;
  }

  Future _autoLogin() async {
    var appAuthService = AppAuthService();

    if (await appAuthService.isAuthentication == true) {
      final service = ServiceProxy();
      this.state.user = await service.userService.getUserInfo();
      this.state.isAuthentication = true;
      await ChatHubConnection().refresh();
      await CallHubConnection().refresh();
      await this._updateDeviceToken(true);
      this.state.screenType = AppStartScreenType.Primary;
    } else {
      var preferences = await SharedPreferences.getInstance();

      if (preferences.containsKey("HideDisplaySlideScreen") &&
          preferences.getBool("HideDisplaySlideScreen")) {
        this.state.screenType = AppStartScreenType.Login;
      } else {
        preferences.setBool("HideDisplaySlideScreen", true);
        this.state.screenType = AppStartScreenType.Slide;
      }
    }
  }

  Future _logout() async {
    await this._updateDeviceToken(false);
    await AppAuthService().clearToken();
    this.state = StateSession();
  }

  Future _login(LoginModel model) async {
    model.applicationId = 1;
    model.companyId = 1;

    final service = ServiceProxy();
    var result = await service.userService.login(model);
    this.state.accessToken = result.accessToken;
    var appAuthService = AppAuthService();
    await appAuthService.setToken(result.accessToken);
    this.state.isAuthentication = true;
    this.state.user = await service.userService.getUserInfo();
    await ChatHubConnection().refresh();
    await CallHubConnection().refresh();
    return this.state;
  }

  // Future _getDoctorCheck() async {
  //   final service = ServiceProxy().doctorCheckServiceProxy;
  //   this.state.doctorCheck = await service.getCompanyDoctorCheck();
  // }
  Future<void> _updateDeviceToken(bool actived) async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var deviceToken = status.subscriptionStatus.userId;

    if (deviceToken != null && deviceToken.isNotEmpty) {
      final service = ServiceProxy().userService;
      var oneSignalAppId = AppConfig().oneSignalAppId;
      await service.updateDeviceToken(CreateDeviceTokenInput(
          deviceToken: deviceToken, actived: actived, appId: oneSignalAppId));
    }
  }

  Future _getUser() async {
    final service = ServiceProxy().userService;
    this.state.user = await service.getUserInfo();
  }

  Future _getUserSummaryReport() async {
    final service = ServiceProxy().reportServiceProxy;
    this.state.userSummaryReport = await service.getUserSummanyReport();
  }

  Future uploadAvatar(File _image) async {
    final services = ServiceProxy();
    var imageBytes = await _image?.readAsBytes();
    _uploadAvatar.avatar = imageBytes != null ? base64Encode(imageBytes) : null;
    await services.userService.uploadAvatar(_uploadAvatar);
    this.state.user = await services.userService.getUserInfo();
  }

  Future _getDetailNotification(String notificationId) async {
    final services = ServiceProxy().notificationServiceProxy;
    var res = await services.getDetailNotification(notificationId);
    this.state.detailNotification = res;
  }
}
