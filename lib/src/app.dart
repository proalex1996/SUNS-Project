import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/app_config.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/call/call_workflow.dart';
import 'package:suns_med/shared/chat/chat_hub_connection.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/conversation/dto/detail_conversation_model.dart';
import 'package:suns_med/src/Widgets/Bottombar/navigator_bar.dart';
import 'package:suns_med/src/account/notification/chat/detail_chat.dart';
import 'package:suns_med/src/appointment/appointment_detail.dart';
import 'package:suns_med/src/signup_signin/login/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:suns_med/src/Widgets/splash_screen.dart';
import 'package:suns_med/src/start/start_screen.dart';
import 'package:suns_med/src/Widgets/call/incoming_call.dart';
import 'account/notification/general/notificationdetail_screen.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/notification/dto/notify_model.dart';
import 'package:suns_med/src/signup_signin/login/session_language_bloc.dart';
import 'package:suns_med/src/signup_signin/login/restart_app.dart';

class MyApp extends StatelessWidget {
  final bloc = SessionBloc();
  final languageBloc = LanguageBloc();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    bloc.dispatch(EventAutoLoginSession());
    Firebase.initializeApp();
    CallWorkflowSetting().init();
    CallWorkflowSetting().onReceiveActionCall = this._navigateInComming;
    ChatHubConnection().onReceiveConversationMessage((conversationId, data) {
      if (ChatHubConnection().conversationActiveId != conversationId) {
        if (data?.isNotEmpty == true) {
          var temp = jsonDecode(data);
          var message = ConversationMessageModel.fromJson(temp);
          _showMessage(conversationId, message);
        }
      }
    });
    configOneSignal();

    return BlocProvider<LanguageEvent, LanguageState, LanguageBloc>(
        bloc: languageBloc,
        builder: (language) {
          return RestartWidget(
            child: MaterialApp(
              builder: (BuildContext context, Widget child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child,
                );
              },
              navigatorKey: AppConfig().navigatorKey,
              // localizationsDelegates: const [
              //   GlobalMaterialLocalizations.delegate,
              //   GlobalWidgetsLocalizations.delegate,
              //   GlobalCupertinoLocalizations.delegate,
              // ],
              // supportedLocales: [
              //   const Locale('zh'),
              //   const Locale('ar'),
              //   const Locale('ja'),
              //   const Locale('vi', 'VN'),
              // ],
              // locale: const Locale('vi', 'VN'),
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: language.isEnglish ? Locale('vi', '') : Locale('en', ''),
              supportedLocales: [
                Locale('vi', ''),
                Locale('en', ''),
              ],
              debugShowCheckedModeBanner: false,
              home: BlocProvider<EventSession, StateSession, SessionBloc>(
                bloc: bloc,
                builder: (state) {
                  switch (state.screenType) {
                    case AppStartScreenType.Slide:
                      return StartScreen();
                      break;
                    case AppStartScreenType.Primary:
                      return BottomBar();
                      break;
                    case AppStartScreenType.Login:
                      return LoginScreen();
                      break;
                    default:
                      return SplashScreen();
                  }
                },
              ),
            ),
          );
        });
  }

  Future _showMessage(
      String conversationId, ConversationMessageModel model) async {
    var context = AppConfig().navigatorKey.currentState.overlay.context;

    Flushbar(
      title: model?.name ?? "Bạn vừa nhận được tin nhắn mới",
      message: model?.content ?? "Bạn vừa nhận được tin nhắn mới",
      duration: Duration(seconds: 5),
      borderRadius: 20,
      icon: Icon(
        Icons.check_circle_outline_sharp,
        color: Colors.green,
      ),
      mainButton: Row(
        children: [
          FlatButton(
            onPressed: () async {
              if (conversationId?.isNotEmpty == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => DetailChat(
                      chatId: conversationId,
                      userId: model?.senderId?.toString(),
                      name: model?.name ?? "",
                      image: model?.image,
                    ),
                  ),
                );
              }
            },
            child: Text(
              "Xem",
              style:
                  TextStyle(fontFamily: 'Montserrat-M', color: AppColor.white),
            ),
          ),
          FlatButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.close, color: AppColor.white),
          ),
        ],
      ),
    )..show(context);
  }

  _navigateInComming(CallInfo callInfo) async {
    var context = AppConfig().navigatorKey.currentState.overlay.context;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => InCommingCall(
          info: CommingCallInfo(
            isInCommingCall: true,
            receiver: callInfo,
          ),
        ),
      ),
    );
  }

  Future<void> configOneSignal() async {
    await OneSignal.shared.init(AppConfig().oneSignalAppId);
    print(AppConfig().oneSignalAppId);

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setNotificationReceivedHandler(
      (notification) {
        var additionalData = notification.payload.additionalData;
        _incomingCall(additionalData);
      },
    );

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      var context = AppConfig().navigatorKey.currentState.overlay.context;
      var additionalData = result.notification.payload.additionalData;

      if (additionalData == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => BottomBar(),
          ),
        );

        return;
      }

      var isIncomingCall = _incomingCall(additionalData);

      if (isIncomingCall == true) {
        print('ok');
      } else {
        var userNotificationId =
            additionalData.containsKey("id") ? additionalData["id"] : null;

        NotifyModel notification;

        if (additionalData.containsKey("notification")) {
          try {
            var data = additionalData["notification"];
            var temp = NotificationModel.fromJson(jsonDecode(data));
            notification = NotifyModel(
              id: userNotificationId,
              type: temp.notificationDefinitionCode,
              title: temp.name,
              message: temp.shortDescription,
              content: temp.description,
              createdTime: temp.createdTime,
              dataExtensionType: temp.dataExtensionType,
              dataExtension: temp.dataExtension,
              severity: temp.severity,
              isRead: false,
            );
          } catch (e) {
            print(e);
          }
        }

        var dataExtension = notification?.dataExtension != null
            ? jsonDecode(notification.dataExtension)
            : null;

        if (notification?.dataExtensionType == 'NotificationAppointmentData' &&
            dataExtension != null &&
            dataExtension['id'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ApponitmentDetail(
                appointmentId: dataExtension['id'],
              ),
            ),
          );
        } else if (notification != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => NotifyDetailScreen(
                notificationId: userNotificationId,
                notifyModel: notification,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => BottomBar(),
            ),
          );
        }
      }
    });
  }

  bool _incomingCall(Map<String, dynamic> additionalData) {
    var result = additionalData != null &&
        additionalData.containsKey("type") &&
        additionalData["type"] == "Call" &&
        additionalData.containsKey("userId");

    if (result) {
      var userId = additionalData["userId"];
      var fullName = additionalData.containsKey("fullName")
          ? additionalData["fullName"]
          : "";

      _navigateInComming(CallInfo(
        id: userId?.toString(),
        name: fullName,
        avatar: null,
      ));
    }

    return result;
  }
}
