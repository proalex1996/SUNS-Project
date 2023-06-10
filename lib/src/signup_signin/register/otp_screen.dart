import 'dart:async';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/common/utils/codeinput.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/register_model.dart';
import 'package:suns_med/common/utils/progressdialog.dart';
import 'package:suns_med/src/signup_signin/login/login_screen.dart';
import 'package:suns_med/src/signup_signin/register/session_register_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/sms_otp_model.dart';
import 'package:suns_med/src/signup_signin/login/session_hotline_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/signup_signin/login/session_language_bloc.dart';

class OTPScreen extends StatefulWidget {
  final RegisterModel registerModel;

  OTPScreen({Key key, @required this.registerModel})
      : assert(registerModel != null),
        super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final blocHotline = HotlineBloc();
  final languageBloc = LanguageBloc();
  ProgressDialog pr;
  String _verificationId;
  int _timeOut = 60;
  final bloc = RegisterBloc();
  final _phoneTextController = TextEditingController();
  final _smsCodeTextController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int resendToken;
  Timer _timer;
  int _index = 0;
  var countdown;

  void restartTimer() {
    setState(() {
      _index++;
      _timeOut = 5;
      _timer.cancel();
      startTimer();
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeOut == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _timeOut--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // bloc.dispatch(EventResetState());
    // _verifyphone();
    blocHotline.dispatch(EventGetHotline());
    _sendSUNSOTP();

    super.initState();
  }

  // RegisterModel registerModel = RegisterModel();
  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 350;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/images/logo.png',
              height: MediaQuery.of(context).size.height * 0.15 - 30,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              AppLocalizations.of(context).enterOTP,
              style: TextStyle(
                fontFamily: 'Montserrat-M',
                color: AppColor.darkPurple,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                AppLocalizations.of(context).sentOTP,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 18),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Text(_checkPhoneNumber(widget.registerModel.phoneNumber),
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 24,
                      color: AppColor.deepBlue)),
            ),
            BlocProvider<RegisterEvent, RegisterState, RegisterBloc>(
                bloc: bloc,
                navigator: (state) {
                  if (state.isRegister == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                },
                builder: (state) {
                  return Container(
                    padding: EdgeInsets.only(
                      bottom: 21,
                      top: 29,
                    ),
                    child: CodeInput(
                      length: 6,
                      onChanged: (value) {
                        _smsCodeTextController.text = value;
                      },
                      keyboardType: TextInputType.number,
                      builder: CodeInputBuilders.darkCircle(),
                      onFilled: (value) async {
                        print('Your input is $value.');
                        // pr.show();
                        Future.delayed(
                          const Duration(milliseconds: 5),
                          () {
                            // pr.hide();
                            // _signInWithPhoneNumberAndSMSCode();
                            _verifySUNSOTP();
                          },
                        );
                      },
                    ),
                  );
                }),
            SizedBox(
              height: 10,
            ),
            _timeOut != 0
                // ? Text("Nhận lại OTP sau $_timeOut giây.")
                ? RichText(
                    text: TextSpan(
                        text: AppLocalizations.of(context).getOTP,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M', color: Colors.black),
                        children: [
                          TextSpan(
                            text: '$_timeOut',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                color: AppColor.deepBlue),
                          ),
                          TextSpan(text: ' giây')
                        ]),
                  )
                : _index == 3
                    ? Text(AppLocalizations.of(context).tryOTPAgain)
                    : MaterialButton(
                        onPressed: _sendSUNSOTP,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text:
                                    '${AppLocalizations.of(context).notReceiveOTP}\n',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 16,
                                    color: Colors.black,
                                    height: 1.5),
                                children: [
                                  TextSpan(
                                    text:
                                        AppLocalizations.of(context).resendOTP,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        color: AppColor.deepBlue),
                                  ),
                                ],
                              ),
                            )),
                      ),
            // SizedBox(
            //   height: useMobileLayout
            //       ? 200
            //       : MediaQuery.of(context).size.height * 0.32,
            // ),
            Expanded(
              child: Container(),
            ),
            _buildHotline(),
          ],
        ),
      ),
    );
  }

  void _signInWithPhoneNumberAndSMSCode() async {
    try {
      AuthCredential authCreds = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _smsCodeTextController.text);
      try {
        final User user =
            (await FirebaseAuth.instance.signInWithCredential(authCreds)).user;
        print("User Phone number is" + user.phoneNumber);
        bloc.dispatch(
          EventRegister(register: this.widget.registerModel),
        );
      } catch (e) {
        if (e is FirebaseAuthException) {
          _showSnackBar(
              Text(AppLocalizations.of(context).resendOTP), Colors.red);
        }
        print('signInWithOTP credential error: $e');
      }

      _smsCodeTextController.text = '';
      _phoneTextController.text = '';
      setState(() => _verificationId = null);
      FocusScope.of(context).requestFocus(FocusNode());
    } catch (e) {
      print('signInWithOTP credential error: $e');
    }
  }

  _checkPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith("0")) {
      return '+84${widget.registerModel.phoneNumber.substring(1)}';
    } else {
      return "+$phoneNumber";
    }
  }

  _resendToken() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _checkPhoneNumber(widget.registerModel.phoneNumber),
      verificationCompleted: (PhoneAuthCredential credential) =>
          print("nguoi dung dang ky"),
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      forceResendingToken: resendToken,
      codeSent: (String verificationId, int resendToken) {
        setState(() {
          _verificationId = verificationId;
          _showSnackBar(Text("Mã xác thực đã được gửi thành công"),
              AppColor.shamrockGreen,
              duration: Duration(seconds: 2));
          restartTimer();
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      timeout: Duration(seconds: _timeOut),
    );
  }

  _verifyphone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _checkPhoneNumber(widget.registerModel.phoneNumber),
      verificationCompleted: (PhoneAuthCredential credential) =>
          print("nguoi dung dang ky"),
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int resendToken) {
        setState(() {
          _verificationId = verificationId;
          this.resendToken = resendToken;
          _showSnackBar(
              Text(AppLocalizations.of(context).sendOTPSuccessfulSnackbar),
              AppColor.shamrockGreen,
              duration: Duration(seconds: 2));
          startTimer();
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      forceResendingToken: resendToken,
      timeout: Duration(seconds: _timeOut),
    );
  }

  _sendSUNSOTP() async {
    try {
      final service = ServiceProxy();
      await service.userService.sendSMSOTP(SendSMSOTPInput(
          phoneNumber: _checkPhoneNumber(widget.registerModel.phoneNumber)));
      _showSnackBar(
          Text(AppLocalizations.of(context).sendOTPSuccessfulSnackbar),
          AppColor.shamrockGreen,
          duration: Duration(seconds: 2));
      setState(() {
        startTimer();
      });
    } catch (e) {
      _showSnackBar(Text(AppLocalizations.of(context).sendOTPErrorSnackbar),
          AppColor.shamrockGreen,
          duration: Duration(seconds: 2));
    }
  }

  _verifySUNSOTP() async {
    try {
      final service = ServiceProxy();
      var token = await service.userService.verifySMSOTP(VerifySMSOTPInput(
          phoneNumber: _checkPhoneNumber(widget.registerModel.phoneNumber),
          otp: _smsCodeTextController.text));
      bloc.dispatch(
        EventRegister(register: this.widget.registerModel),
      );
    } catch (e) {
      _showSnackBar(Text(AppLocalizations.of(context).expiredOTPSnackbar),
          AppColor.shamrockGreen,
          duration: Duration(seconds: 2));
    }
  }

  void _showSnackBar(Widget content, Color color, {Duration duration}) {
    final snackBar = SnackBar(
      content: content,
      backgroundColor: color,
      duration: duration,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
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
