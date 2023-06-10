import 'package:flutter/material.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/forgot_password_model.dart';
import 'package:suns_med/src/signup_signin/forgotpass/otp_screen.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/signup_signin/login/session_hotline_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/signup_signin/login/session_language_bloc.dart';

class ForgotPassScreen extends StatefulWidget {
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final blocHotline = HotlineBloc();
  final languageBloc = LanguageBloc();
  final TextEditingController _controller = TextEditingController();
  ForgotPasswordModel _forgotPassword = ForgotPasswordModel();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    blocHotline.dispatch(EventGetHotline());
    super.initState();
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: globalFormKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.15 - 30,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.only(top: 37),
                    child: Image.asset('assets/images/quenmk.png')),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  width: 311,
                  height: 49,
                  child: Text(
                    AppLocalizations.of(context).descript_recoveryPass,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.purple),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: TextFormField(
                        onChanged: (t) {
                          _forgotPassword.phoneNumber = t;
                        },
                        controller: _controller,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 16,
                            color: Colors.black),
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.phone,
                        validator: (input) {
                          String message;
                          if (input.isEmpty) {
                            message = AppLocalizations.of(context).isPhoneEmpty;
                          } else if (_checkPhoneNumber(input) == false) {
                            message = "Số điện thoại không hợp lệ";
                          }
                          // else if (!input.startsWith("0", 1) ||
                          //     !input.startsWith('84', 2)) {
                          //   message = "Số điện thoại không hợp lệ";
                          // }

                          return message;
                        },
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).phoneNumber,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    )),
                SizedBox(height: 40),
                Container(
                  width: 312,
                  height: 46,
                  child: RaisedButton(
                      onPressed: () {
                        final form = globalFormKey.currentState;
                        if (form.validate()) {
                          form.save();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OTPPasswordScreen(
                                        forgotPassword: _forgotPassword,
                                      )));
                        }
                      },
                      color: AppColor.purple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Text(
                        AppLocalizations.of(context).recoveryPass,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            color: Colors.white,
                            fontSize: 16),
                      )),
                ),
                SizedBox(height: 40),
                _buildHotline(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _checkPhoneNumber(String phoneNumber) {
    var a = phoneNumber.startsWith("0");
    var b = phoneNumber.startsWith("84");
    if (a == true && phoneNumber.length == 10 ||
        b == true && phoneNumber.length == 11) {
      return true;
    }
    return false;
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
