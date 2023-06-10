import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/dialog/msg_dialog.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/change_password_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/login_model.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/signup_signin/login/login_screen.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suns_med/src/signup_signin/login/session_hotline_bloc.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/signup_signin/login/session_language_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> globalFormNewPasswordKey =
      GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> globalFormCurrentPasswordKey =
      GlobalKey<FormFieldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ChangePasswordModel changePasswordModel = ChangePasswordModel();
  final blocHotline = HotlineBloc();
  final blocSession = SessionBloc();
  final languageBloc = LanguageBloc();
  LoginModel loginModel;
  bool isApiCallProcess = false;
  bool isSelect = true;
  FocusNode _currentFocus = new FocusNode();
  FocusNode _newFocus = new FocusNode();

  Future _changePassword() async {
    if (validateAndSave()) {
      isApiCallProcess = true;
      try {
        final service = ServiceProxy();
        changePasswordModel.oldPassword = _currentPassword.text;
        changePasswordModel.newPassword = _newPassword.text;
        changePasswordModel.newPassword = _confirmPassword.text;
        await service.userService.changePassword(changePasswordModel);
        // Flushbar(
        //   title: "Đổi mật khẩu thành công",
        //   message: "Vui lòng đặt nhập lại",
        //   duration: Duration(seconds: 3),
        //   borderRadius: 20,
        //   borderColor: AppColor.shamrockGreen,
        //   icon: Icon(Icons.check_circle_outline_sharp),
        //   mainButton: FlatButton(
        //     onPressed: () {
        //       Navigator.of(context).pop(true);
        //       Navigator.of(context).pop(true);
        //     },
        //     child: Text(
        //       "Ok",
        //       style:TextStyle(
        //     fontFamily: 'Montserrat-M',color: AppColor.white),
        //     ),
        //   ),
        // )..show(context);
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Text(
              "Đổi mật khẩu thành công vui lòng đăng nhập lại!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  color: Colors.black,
                  fontSize: Theme.of(context).textTheme.headline6.fontSize),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  SessionBloc().stream.listen((event) {
                    if (event.isAuthentication != true) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()),
                        ModalRoute.withName('/'),
                      );
                    }
                  });

                  SessionBloc().dispatch(EventLogoutSession());
                },
                child: Text("Đăng nhập lại",
                    style: TextStyle(
                        fontFamily: 'Montserrat-M', color: AppColor.deepBlue)),
              ),
              // CupertinoDialogAction(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: Text("Đóng",
              //       style:TextStyle(
              //              fontFamily: 'Montserrat-M',color: AppColor.deepBlue)),
              // )
            ],
          ),
        );
      } catch (e) {
        isApiCallProcess = false;
        MsgDialog.showMsgDialog(context, "Đổi mật khẩu", '$e');
      }
    }
  }

  bool _validateCurrentPassword = false;
  bool _validateNewPassword = false;

  @override
  void initState() {
    _currentFocus.addListener(_onFocusCurrentPasswordChange);
    _newFocus.addListener(_onFocusNewPasswordChange);
    blocHotline.dispatch(EventGetHotline());
    super.initState();
  }

  void _onFocusCurrentPasswordChange() async {
    _validateCurrentPassword = validateStructure(_currentPassword.text);
    var isValid = globalFormCurrentPasswordKey.currentState.validate();
    globalFormCurrentPasswordKey.currentState.save();

    if (isValid == true) {}
  }

  void _onFocusNewPasswordChange() async {
    _validateNewPassword = validateStructure(_newPassword.text);
    var isValid = globalFormNewPasswordKey.currentState.validate();
    globalFormNewPasswordKey.currentState.save();

    if (isValid == true) {}
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 350;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.white,
      appBar: const TopAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: globalFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: language.changePassword,
                isSmallOrangeAppBar: true,
              ),
              SizedBox(
                height: 20,
              ),
              _buildTitle(language.enterOldPass),
              SizedBox(
                height: 12,
              ),
              _oldpasswordTextfield(language.enterOldPass),
              SizedBox(
                height: 23,
              ),
              _buildTitle(language.enterNewPass),
              SizedBox(
                height: 12,
              ),
              _newpasswordTextfield(language.enterNewPass),
              SizedBox(
                height: 21,
              ),
              _buildTitle(language.reEnterNewPass),
              SizedBox(
                height: 16,
              ),
              _confirmPasswordTextfield(language.reEnterNewPass),
              SizedBox(
                height: 10,
              ),
              // _checkRePassword(),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
              //   child: Text(
              //     "Mật khẩu phải gồm ít nhất 8 ký tự (gồm chữ hoa, chữ thường, số và ký tự đặc biệt).",
              //     textAlign: TextAlign.center,
              //     style:TextStyle(
              //  fontFamily: 'Montserrat-M',
              //         fontSize: 14,
              //         color: validateStructure(_newPassword.text) == false
              //             ? Colors.red
              //             : Colors.black),
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                child: CustomButton(
                  color: AppColor.purple,
                  onPressed: () {
                    setState(() {
                      if (validateAndSave() == true &&
                          validateStructure(_newPassword.text) == true) {
                        if (_newPassword.text == _confirmPassword.text) {
                          _changePassword();
                        } else {
                          // setState(() {});
                        }
                      } else {
                        // setState(() {});@
                      }
                    });
                  },
                  radius: BorderRadius.circular(20),
                  text: language.confirm,
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: useMobileLayout
                    ? 60
                    : MediaQuery.of(context).size.height * 0.11,
              ),
              Container(
                child: _buildHotline(),
              )
            ],
          ),
        ),
      ),
    );
  }

  // _checkRePassword() {
  //   if (_newPassword.text == _confirmPassword.text) {
  //     return Container();
  //   } else {
  //     return Padding(
  //       padding: const EdgeInsets.only(left: 31, right: 31),
  //       child: Row(
  //         children: [
  //           Icon(
  //             Icons.error,
  //             color: Colors.red,
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           Text(
  //             "Mật khẩu không khớp. Hãy thử lại.",
  //             style:TextStyle(
  //        fontFamily: 'Montserrat-M',color: Colors.red),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 31.0),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Montserrat-M', fontSize: 16, color: AppColor.purple),
      ),
    );
  }

  _oldpasswordTextfield(String hintext) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.only(left: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: _currentPassword,
        key: globalFormCurrentPasswordKey,
        style: TextStyle(
            fontFamily: 'Montserrat-M', color: Theme.of(context).accentColor),
        keyboardType: TextInputType.text,
        onSaved: (input) => changePasswordModel.oldPassword = input,
        validator: (input) {
          String message;
          if (_validateCurrentPassword != true) {
            message = AppLocalizations.of(context).passValidate1;
          } else if (input.isEmpty) {
            message = "Không được bỏ trống.";
          }
          return message;
        },
        obscureText: isSelect,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: hintext,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isSelect = !isSelect;
              });
            },
            color: Colors.black12,
            icon: Icon(isSelect ? Icons.visibility_off : Icons.visibility),
          ),
        ),
      ),
    );
  }

  bool validateStructure(String value) {
    if (value == null || value.isEmpty) {
      return true;
    } else {
      String pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(value);
    }
  }

  _newpasswordTextfield(String hintext) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.only(left: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: TextFormField(
        focusNode: _currentFocus,
        controller: _newPassword,
        key: globalFormNewPasswordKey,
        style: TextStyle(
            fontFamily: 'Montserrat-M', color: Theme.of(context).accentColor),
        keyboardType: TextInputType.text,
        onSaved: (input) => changePasswordModel.newPassword = input,
        validator: (input) {
          String message;
          if (_validateNewPassword != true) {
            message = AppLocalizations.of(context).passValidate1;
          } else if (input.isEmpty) {
            message = AppLocalizations.of(context).notEmpty;
          } else if (_currentPassword.text == input) {
            message = AppLocalizations.of(context).passDuplicate;
          }
          return message;
        },
        obscureText: isSelect,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: hintext,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isSelect = !isSelect;
              });
            },
            color: Colors.black12,
            icon: Icon(isSelect ? Icons.visibility_off : Icons.visibility),
          ),
        ),
      ),
    );
  }

  _confirmPasswordTextfield(String hintext) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.only(left: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(_newFocus);
        },
        child: TextFormField(
          focusNode: _newFocus,
          controller: _confirmPassword,
          style: TextStyle(
              fontFamily: 'Montserrat-M', color: Theme.of(context).accentColor),
          keyboardType: TextInputType.text,
          onSaved: (input) => changePasswordModel.newPassword = input,
          validator: (input) {
            String message;
            if (input.isEmpty) {
              message = AppLocalizations.of(context).notEmpty;
            } else if (_newPassword.text != _confirmPassword.text) {
              message = AppLocalizations.of(context).notLikeNewPass;
            }
            return message;
          },
          obscureText: isSelect,
          obscuringCharacter: "*",
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            hintText: hintext,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isSelect = !isSelect;
                });
              },
              color: Colors.black12,
              icon: Icon(isSelect ? Icons.visibility_off : Icons.visibility),
            ),
          ),
        ),
      ),
    );
  }

  _buildHotline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          width: 140,
          height: 35,
          child: OutlinedButton(
            onPressed: () {
              languageBloc.dispatch(EventLanguage());
            },
            style: ButtonStyle(
                backgroundColor: (languageBloc.state.isEnglish)
                    ? MaterialStateProperty.all(Colors.white)
                    : MaterialStateProperty.all(AppColor.purple),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)))),
            child: Row(
              children: [
                Image.asset('assets/images/icon-english.png'),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'English',
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
        BlocProvider<HotlineEvent, HotlineState, HotlineBloc>(
          bloc: blocHotline,
          builder: (state) {
            String hotline = state.hotline ?? '0932108534';
            return Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: 190,
              height: 35,
              child: OutlinedButton(
                onPressed: () {
                  launch("tel://$hotline");
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/imgclinic/ic_phone.png',
                      height: 24,
                      width: 24,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        AppLocalizations.of(context).callHotline,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
