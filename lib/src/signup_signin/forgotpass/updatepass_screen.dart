import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/forgot_password_model.dart';
import 'package:suns_med/src/signup_signin/forgotpass/session_forgot_bloc.dart';
import 'package:suns_med/src/signup_signin/login/login_screen.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class UpdatePassScreen extends StatefulWidget {
  final ForgotPasswordModel forgotPasswordModel;
  UpdatePassScreen({Key key, @required this.forgotPasswordModel})
      : super(key: key);
  @override
  _UpdatePassScreenState createState() => _UpdatePassScreenState();
}

class _UpdatePassScreenState extends State<UpdatePassScreen> {
  ForgotPasswordModel _forgotPasswordModel = ForgotPasswordModel();
  final TextEditingController _passController = TextEditingController();

  // Future updatePass() async {
  //   final service = ServiceProxy();
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //   await service.userService.forgotPass(_forgotPasswordModel);
  // }
  final bloc = ForgotBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSelect = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _forgotPasswordModel = this.widget.forgotPasswordModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocProvider<ForgotEvent, ForgotState, ForgotBloc>(
        bloc: bloc,
        navigator: (state) {
          if (state.isUpdated == true) {
            _showSnackBar('Cập nhật mật khẩu thành công.');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => LoginScreen(),
              ),
            );
          }
        },
        builder: (state) {
          return SingleChildScrollView(
            child: Form(
              key: globalFormKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/nhapmatkhaumoi.png'),
                      Container(
                        margin: EdgeInsets.only(top: 36),
                        width: 311,
                        height: 49,
                        child: Text(
                          'Vui lòng nhập mật khẩu mới cho tài khoản của bạn',
                          style: TextStyle(
                              fontFamily: 'Montserrat-M', fontSize: 16),
                        ),
                      ),
                      _passwordTextfield("Nhập mật khẩu mới"),
                      Container(
                        margin: EdgeInsets.only(top: 27),
                        width: 312,
                        height: 46,
                        child: RaisedButton(
                            onPressed: () {
                              final form = globalFormKey.currentState;
                              if (form.validate()) {
                                form.save();
                                bloc.dispatch(EventRePassword(
                                    forgotPassword: _forgotPasswordModel));
                              }
                            },
                            color: AppColor.deepBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Text(
                              "Cập nhật",
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool validateStructure(String value) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      String pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(value);
    }
  }

  _passwordTextfield(String hintext) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      padding: const EdgeInsets.only(left: 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black12,
              offset: Offset(0, 0),
            )
          ]),
      child: TextFormField(
        controller: _passController,
        style: TextStyle(
            fontFamily: 'Montserrat-M', color: Theme.of(context).accentColor),
        keyboardType: TextInputType.text,
        // onSaved: (input) => registerModel.password = input,
        onChanged: (input) {
          _forgotPasswordModel.password = input;
        },
        validator: (input) {
          String message;
          if (validateStructure(_passController.text) != true) {
            message =
                "Mật khẩu phải gồm ít nhất 8 ký tự (gồm chữ hoa, chữ thường, số và ký tự đặc biệt).";
          }
          return message;
        },
        obscureText: isSelect,
        decoration: InputDecoration(
          hintText: hintext,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
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

  void _showSnackBar(msg) {
    final snackBar = SnackBar(content: Text(msg));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
