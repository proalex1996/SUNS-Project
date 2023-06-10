import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/login_model.dart';
import 'package:suns_med/src/Widgets/Bottombar/navigator_bar.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/signup_signin/login/session_hotline_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suns_med/src/signup_signin/forgotpass/forgot_pass.dart';
import 'package:suns_med/src/signup_signin/register/register_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/signup_signin/login/session_language_bloc.dart';
import 'package:suns_med/src/signup_signin/login/restart_app.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSelect = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  LoginModel loginModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String notifyContent;
  var deviceId;
  final bloc = SessionBloc();
  final blocHotline = HotlineBloc();
  final languageBloc = LanguageBloc();
  @override
  void initState() {
    blocHotline.dispatch(EventGetHotline());
    super.initState();
    loginModel = LoginModel();
    getPermissionSubcriptionState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventSession, StateSession, SessionBloc>(
      navigator: (state) {
        if (state.isAuthentication == true) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (ctx) => BottomBar()),
              (Route<dynamic> route) => false);
        }
      },
      bloc: bloc,
      builder: (state) {
        return Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Form(
                key: globalFormKey,
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
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Image.asset(
                        'assets/images/dangnhap.png',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildText(AppLocalizations.of(context).login, 24),
                    SizedBox(
                      height: 15,
                    ),
                    _buildText(AppLocalizations.of(context).phoneNumber, 16),
                    SizedBox(height: 7),
                    _buildSignInTextField(),
                    SizedBox(
                      height: 10,
                    ),
                    _buildRowForgotPass(),
                    SizedBox(
                      height: 10,
                    ),
                    _builCustomContainer(),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildRowRegister(),
                    _buildHotline()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildText(String text, double size) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.only(left: 30),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              color: AppColor.darkPurple,
              fontWeight: FontWeight.bold,
              fontSize: size),
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

  _buildRowForgotPass() {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: const EdgeInsets.only(right: 31, top: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPassScreen()));
        },
        child: Text(
          AppLocalizations.of(context).forgotPass,
          style: TextStyle(
            fontFamily: 'Montserrat-M',
            fontSize: 16,
            color: Color(0xff6a6d7e),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
  // initConnection() async {
  //   await connection?.stop();
  //   connection = HubConnectionBuilder()
  //       .withUrl(
  //         'http://uat-sunsdemo-messenger.sunsoftware.vn/ChatHub',
  //         HttpConnectionOptions(
  //           logging: (level, message) => print(message),
  //           transport: HttpTransportType.longPolling,
  //           accessTokenFactory: () async {
  //             return bloc.state.accessToken;
  //           },
  //         ),
  //       )
  //       .withAutomaticReconnect()
  //       .build();
  //   await connection.start();

  //   connection.on('ReceiveMessage', (message) {
  //     if (message.length == 3) {
  //       var senderId = message[0];
  //       var receiverId = message[1];
  //       var content = message[2];
  //       print(senderId.toString());
  //       print(receiverId.toString());
  //       print(content.toString());
  //     }
  //     print(message.toString());
  //   });

  //   // await connection.invoke('SendMessage', args: ['Bob', 'Says hi!']);
  // }

  Future<void> getPermissionSubcriptionState() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    loginModel.deviceToken = status.subscriptionStatus.userId;
  }

  _buildSignInTextField() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          padding: const EdgeInsets.only(left: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (input) => loginModel.userName = input,
            validator: (input) => input.length < 10 || input.length > 11
                ? AppLocalizations.of(context).phoneNumberError
                : null,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              hintText: AppLocalizations.of(context).phoneNumber,
            ),
          ),
        ),
        SizedBox(height: 12),
        _buildText(AppLocalizations.of(context).password, 16),
        SizedBox(height: 7),
        Container(
          margin: EdgeInsets.only(left: 31, right: 31),
          padding: const EdgeInsets.only(left: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
            // boxShadow: [
            //   BoxShadow(
            //       blurRadius: 15, color: Colors.black12, offset: Offset(0, 0))
            // ],
          ),
          child: TextFormField(
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                color: Theme.of(context).accentColor),
            keyboardType: TextInputType.text,
            onSaved: (input) => loginModel.password = input,
            validator: (input) => input.length < 3
                ? AppLocalizations.of(context).passwordError
                : null,
            obscureText: isSelect,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              hintText: AppLocalizations.of(context).password,
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
      ],
    );
  }

  // _buildRowIcons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: <Widget>[
  //       Column(
  //         children: <Widget>[
  //           Image.asset(
  //             'assets/images/ic_fb.png',
  //             width: 30,
  //             height: 30,
  //           ),
  //           SizedBox(
  //             height: 6,
  //           ),
  //           Text(
  //             'Facebook',
  //             style:TextStyle(
  //           fontFamily: 'Montserrat-M',fontSize: 13, color: Color(0xff6a6d7e)),
  //           )
  //         ],
  //       ),
  //       Column(
  //         children: <Widget>[
  //           Image.asset(
  //             'assets/images/ic_zalo.png',
  //             width: 30,
  //             height: 30,
  //           ),
  //           SizedBox(
  //             height: 6,
  //           ),
  //           Text(
  //             'Zalo',
  //             style:TextStyle(
  //          fontFamily: 'Montserrat-M',fontSize: 13, color: Color(0xff6a6d7e)),
  //           )
  //         ],
  //       ),
  //       Column(
  //         children: <Widget>[
  //           Image.asset(
  //             'assets/images/ic_email.png',
  //             width: 30,
  //             height: 30,
  //           ),
  //           SizedBox(
  //             height: 6,
  //           ),
  //           Text(
  //             'Email',
  //             style:TextStyle(
  //                fontFamily: 'Montserrat-M',fontSize: 13, color: Color(0xff6a6d7e)),
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }

  _buildRowRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          '${AppLocalizations.of(context).noAccount} ? ',
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              fontSize: 16,
              color: Color(0xff6a6d7e)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
          child: Text(
            AppLocalizations.of(context).registerNow,
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.deepBlue),
          ),
        )
      ],
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _builCustomContainer() {
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 10, bottom: 10),
      child: CustomButton(
        color: AppColor.purple,
        radius: BorderRadius.circular(26),
        text: AppLocalizations.of(context).login,
        style: TextStyle(
            fontFamily: 'Montserrat-M', fontSize: 16, color: Colors.white),
        onPressed: () {
          final form = globalFormKey.currentState;
          if (form.validate()) {
            form.save();
            SessionBloc().dispatch(EventLoginSession(loginModel: loginModel));
          }
        },
        // onPressed: () {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (ctx) => BottomBar()));
        // },
      ),
    );
  }
}
