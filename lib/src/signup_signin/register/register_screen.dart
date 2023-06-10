import 'package:flutter/material.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/check_exist_phone_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/register_model.dart';
import 'package:suns_med/src/signup_signin/register/otp_screen.dart';
import 'package:suns_med/src/signup_signin/register/session_register_bloc.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/signup_signin/login/session_hotline_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/signup_signin/login/login_screen.dart';
import 'package:suns_med/src/signup_signin/login/session_language_bloc.dart';
import 'package:suns_med/src/account/webview_policy.dart';
import 'package:suns_med/src/account/session_usagepolicy_bloc.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> globalFormPhoneNumberKey =
      GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> globalFormRePasswordKey =
      GlobalKey<FormFieldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  RegisterModel registerModel = new RegisterModel();
  bool isApiCallProcess = false;
  bool checked = false;
  bool isSelect = true;
  final bloc = RegisterBloc();
  FocusNode _focus = new FocusNode();
  CheckExistPhoneModel checkExist = CheckExistPhoneModel();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _rePassController = TextEditingController();
  FocusNode _focusNode = new FocusNode();
  String text = '';
  final blocHotline = HotlineBloc();
  final languageBloc = LanguageBloc();
  final policyBloc = PolicyBloc();

  @override
  void initState() {
    blocHotline.dispatch(EventGetHotline());
    policyBloc.dispatch(EventGetData());

    _focus.addListener(_onFocusChange);
    _focusNode.addListener(_onFocusPasswordChange);
    super.initState();

    registerModel =
        RegisterModel(applicationId: 1, companyId: 1, deviceToken: "");
  }

  bool _phoneExist = false;
  bool _validatePassword = false;

  Future<bool> _checkExistPhone(CheckExistPhoneModel phoneNumber) async {
    try {
      final service = ServiceProxy().userService;
      await service.checkExistPhone(phoneNumber);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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

  void _onFocusChange() async {
    _phoneExist = false;
    _phoneExist = await _checkExistPhone(checkExist);
    var isValid = globalFormPhoneNumberKey.currentState.validate();
    globalFormPhoneNumberKey.currentState.save();

    if (isValid == true) {}
  }

  void _onFocusPasswordChange() async {
    _validatePassword = validateStructure(_passController.text);
    var isValid = globalFormRePasswordKey.currentState.validate();
    globalFormRePasswordKey.currentState.save();

    if (isValid == true) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      resizeToAvoidBottomInset: false, // this is new
      resizeToAvoidBottomPadding: false, // this is new
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 30),
          child: Form(
            key: globalFormKey,
            child: SingleChildScrollView(
              reverse: true,
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
                  Image.asset('assets/images/dangky.png'),
                  SizedBox(
                    height: 20,
                  ),
                  _buildText(AppLocalizations.of(context).register, 24),
                  SizedBox(
                    height: 15,
                  ),
                  _buildText(AppLocalizations.of(context).phoneNumber, 16),
                  SizedBox(height: 7),
                  _buildPhoneTextField(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildText(AppLocalizations.of(context).password, 16),
                  SizedBox(height: 7),
                  _passwordTextfield(AppLocalizations.of(context).password),
                  SizedBox(
                    height: 15,
                  ),
                  _buildText(AppLocalizations.of(context).reEnterPass, 16),
                  SizedBox(height: 7),
                  _confirmPasswordTextfield(
                      AppLocalizations.of(context).reEnterPass),
                  SizedBox(
                    height: 7,
                  ),
                  _checkRePassword(),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 20.0, right: 20, bottom: 10),
                  //   child: Text(
                  //     "Mật khẩu phải gồm ít nhất 8 ký tự (gồm chữ hoa, chữ thường, số và ký tự đặc biệt).",
                  //     textAlign: TextAlign.center,
                  //     style:TextStyle(
                  //                    fontFamily: 'Montserrat-M',
                  //         fontSize: 14,
                  //         color:
                  //             validateStructure(_passController.text) == false
                  //                 ? Colors.red
                  //                 : Colors.black),
                  //   ),
                  // ),
                  buildCheckBox(),

                  SizedBox(
                    height: 15,
                  ),

                  Container(
                    width: 312,
                    height: 46,
                    child: RaisedButton(
                        onPressed: () {
                          if (checked != false) {
                            if (validateAndSave() == true &&
                                validateStructure(_passController.text) ==
                                    true) {
                              if (_passController.text ==
                                  _rePassController.text) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OTPScreen(
                                              registerModel: registerModel,
                                            )));
                              } else {
                                setState(() {});
                              }
                            } else {
                              setState(() {});
                            }
                          }
                        },
                        color: AppColor.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Text(
                          AppLocalizations.of(context).register,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: Colors.white,
                              fontSize: 16),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildRowRegister(),
                  SizedBox(
                    height: 5,
                  ),
                  _buildHotline(),
                  // Padding(
                  //     // this is new
                  //     padding: EdgeInsets.only(
                  //         bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildCheckBox() {
    return Row(
      children: [
        Checkbox(
          activeColor: AppColor.deepBlue,
          checkColor: Colors.white,
          // fillColor: MaterialStateProperty.resolveWith(getColor),
          value: checked,
          tristate: false,
          onChanged: (bool value) {
            setState(() {
              checked = value;
            });
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).term,
              style: TextStyle(
                  fontFamily: 'Montserrat-M', color: AppColor.darkPurple),
            ),
            InkWell(
                child: Text(
                  'Điều khoản sử dụng',
                  style: TextStyle(
                    color: AppColor.orangeColor,
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewUrlPolicy(
                        url: policyBloc?.state?.data,
                      ),
                    ),
                  );
                }),
          ],
        ),
      ],
    );
  }

  Container _buildPhoneTextField() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: TextFormField(
        key: globalFormPhoneNumberKey,
        keyboardType: TextInputType.phone,
        onChanged: (input) {
          registerModel.phoneNumber = input;
          checkExist.phoneNumber = registerModel.phoneNumber;
        },
        validator: (input) {
          String message;
          if (input.isEmpty) {
            message = AppLocalizations.of(context).isPhoneEmpty;
          } else if (_phoneExist != true) {
            message = AppLocalizations.of(context).isPhoneAlready;
          } else if (_checkPhoneNumber(input) == false) {
            message = AppLocalizations.of(context).passwordError;
          }
          // else if (!input.startsWith("0", 1) ||
          //     !input.startsWith('84', 2)) {
          //   message = "Số điện thoại không hợp lệ";
          // }

          return message;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: AppLocalizations.of(context).phoneNumber,
        ),
      ),
    );
  }

  _checkRePassword() {
    if (_passController.text == _rePassController.text) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 31, right: 31),
        child: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              AppLocalizations.of(context).passwordError,
              style: TextStyle(fontFamily: 'Montserrat-M', color: Colors.red),
            ),
          ],
        ),
      );
    }
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

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _passwordTextfield(String hintext) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: _passController,
        focusNode: _focus,
        style: TextStyle(
            fontFamily: 'Montserrat-M', color: Theme.of(context).accentColor),
        key: globalFormRePasswordKey,
        keyboardType: TextInputType.text,
        // onSaved: (input) => registerModel.password = input,
        onChanged: (input) {
          registerModel.password = input;
        },
        validator: (input) {
          String message;
          if (_validatePassword != true) {
            message = AppLocalizations.of(context).passValidate1;
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
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: TextFormField(
          focusNode: _focusNode,
          controller: _rePassController,
          style: TextStyle(
              fontFamily: 'Montserrat-M', color: Theme.of(context).accentColor),
          keyboardType: TextInputType.text,
          onChanged: (input) {
            registerModel.password = input;
          },
          validator: (input) => input.length < 8 || input.length > 15
              ? AppLocalizations.of(context).passValidate2
              : null,
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

  _buildText(String text, double size) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.only(left: 15),
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

  _buildRowRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          '${AppLocalizations.of(context).hasAccount} ? ',
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              fontSize: 16,
              color: Color(0xff6a6d7e)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          child: Text(
            AppLocalizations.of(context).loginNow,
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
