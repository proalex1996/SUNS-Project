import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/app_config.dart';
import 'package:suns_med/shared/unauthorized_access_exception.dart';
import 'package:suns_med/shared/user_friendly_exception.dart';
import 'package:suns_med/src/signup_signin/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GlobalFilterError {
  var _isOpen = false;

  static final GlobalFilterError _instance = GlobalFilterError._internal();
  GlobalFilterError._internal();

  factory GlobalFilterError() {
    return _instance;
  }

  displayError(dynamic error) {
    if (!_isOpen) {
      _isOpen = true;
      if (error is UnauthorizedAccessException) {
        //Todo show dialog confirm redirect login page
        !Platform.isIOS
            ? showDialog(
                context: AppConfig().navigatorKey.currentState.overlay.context,
                builder: (context) => Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: AlertDialog(
                    // backgroundColor: Colors.transparent,

                    elevation: 0,
                    // title: ,
                    content: Text(
                      AppLocalizations.of(context).loginExpired,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.headline6.fontSize),
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => LoginScreen()));
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()),
                            ModalRoute.withName('/'),
                          );
                        },
                        child: Text(AppLocalizations.of(context).reLogin,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                color: AppColor.deepBlue)),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context).close,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                color: AppColor.deepBlue)),
                      )
                    ],
                  ),
                ),
              ).then((value) => _isOpen = false)
            : showCupertinoDialog(
                context: AppConfig().navigatorKey.currentState.overlay.context,
                builder: (context) => CupertinoAlertDialog(
                  content: Text(
                    AppLocalizations.of(context).loginExpired,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        color: Colors.black,
                        fontSize:
                            Theme.of(context).textTheme.headline6.fontSize),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(AppLocalizations.of(context).reLogin,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: AppColor.deepBlue)),
                    ),
                    CupertinoDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context).close,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: AppColor.deepBlue)),
                    )
                  ],
                ),
              ).then((value) => _isOpen = false);
      } else {
        var message = _getErrorMessage(error);

        !Platform.isIOS
            ? showDialog(
                context: AppConfig().navigatorKey.currentState.overlay.context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  // elevation: 0,

                  content: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red,
                      ),
                      Flexible(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: Colors.red,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .fontSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ).then((value) => _isOpen = false)
            : showCupertinoDialog(
                context: AppConfig().navigatorKey.currentState.overlay.context,
                builder: (context) => CupertinoAlertDialog(
                  // title: Text("title"),

                  content: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red,
                      ),
                      Flexible(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: Colors.red,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .fontSize),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context).close,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: AppColor.deepBlue)),
                    )
                  ],
                ),
              ).then((value) => _isOpen = false);
      }
    }
  }

  String _getErrorMessage(dynamic error) {
    var result = "";

    if (error is SocketException) {
      result = "Kiểm tra lại kết nối mạng!";
    } else if (error is UserFriendlyException) {
      result = error.message;
    } else if (AppConfig().production != true) {
      result = error.toString();
    }

    return result?.isNotEmpty == true ? result : "Lỗi ứng dụng!";
  }
}
