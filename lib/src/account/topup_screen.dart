import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:momo_vn/momo_vn.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/Bottombar/navigator_bar.dart';
import 'package:suns_med/src/account/choose_topup_model.dart';
import 'package:suns_med/src/account/session_topup_bloc.dart';
import 'package:suns_med/src/account/weburl_recharge_screen.dart';

class TopupScreen extends StatefulWidget {
  @override
  _TopupScreenState createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  final TextEditingController _textController = TextEditingController();
  final bloc = ChooseTopupBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
  bool isShowSuggestMoney = false;

  List<String> suggestInput1 = ["100.000", "1.000.000", "10.000.000"];
  List<String> suggestInput2 = ["200.000", "2.000.000", "3.000.000"];

  MomoVn _momoPay;

  PaymentResponse momoPaymentResult;

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  // final formatCurrency = new NumberFormat.simpleCurrency();
  final formatCurrency = NumberFormat('#,###,000');

  bool _isVisible = false;
  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardVisibilityController.onChange.listen(
      (bool visible) {
        _isVisible = visible;
      },
    );
    super.initState();
    bloc.dispatch(EventGetDeepLink());
    _momoPay = MomoVn();
    _momoPay.on(MomoVn.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _momoPay.on(MomoVn.EVENT_PAYMENT_ERROR, _handlePaymentError);
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final positionButton = _isVisible == true ? 50.0 : 10.0;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: Text(
          "Nạp tiền vào ví",
          style: TextStyle(
              fontFamily: 'Montserrat-M', color: AppColor.white, fontSize: 18),
        ),
      ),
      body: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView(
            children: [_item()],
          ),
          Positioned(
            bottom: positionButton,
            child: BlocProvider<ChooseTopupEvent, ChooseTopupState,
                ChooseTopupBloc>(
              bloc: bloc,
              navigator: (state) {
                if (state.checkPayment == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => WebUrlRechargeExample(),
                    ),
                  );
                } else if (state.paid == true) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomBar(
                            // index: 4,
                            ),
                      ),
                      (route) => false);
                }
              },
              builder: (state) {
                return Container(
                  padding: const EdgeInsets.only(
                    left: 21,
                    right: 21,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 46,
                  color: Colors.white,
                  child: RaisedButton(
                    color: AppColor.deepBlue,
                    onPressed: () async {
                      var moneyValue = _textController.text.replaceAll(',', '');

                      if (int.parse(moneyValue) >= 20000) {
                        if (state.topupId == 0) {
                          MomoPaymentInfo options = MomoPaymentInfo(
                              merchantname: state.deepLink.merchantName,
                              appScheme: state.deepLink.appScheme,
                              merchantcode: state.deepLink.merchantCode,
                              amount: double.parse(moneyValue),
                              orderId: "${getRandomString(5)}}",
                              orderLabel: 'Gói dịch vụ Gcare',
                              // merchantnamelabel: "TRUNG TÂM XYZ",
                              fee: 0,
                              description: 'Nạp tiền vào Gcare',
                              // username: '0948819199',
                              partner: 'a001',
                              // extra: "{\"key1\":\"value1\",\"key2\":\"value2\"}",
                              isTestMode: true);
                          try {
                            _momoPay.open(options);
                          } catch (e) {
                            debugPrint(e);
                          }
                        } else if (state.topupId == 1 || state.topupId == 2) {
                          bloc.dispatch(
                            EventrechargeVnPay(
                              amount: int.parse(moneyValue),
                            ),
                          );
                        }
                      } else {
                        _showSnackBar('Vui lòng nhập giá trị trên 20.000 vnđ');
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Text(
                      "Nạp tiền",
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
          _isVisible == true
              ? Positioned(
                  bottom: 0,
                  child: SuggestMoneyItem(
                    value: _textController,
                    onClick: () {},
                    onChange: (value) {
                      setState(() {
                        // final currencyFormatter =
                        //     NumberFormat.currency(locale: 'vi_VN', symbol: "");

                        _textController.text = value;
                        // "${currencyFormatter.format(int.parse(value))}";
                      });
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  _item() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 21, right: 21, top: 20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 0),
            ),
          ], borderRadius: BorderRadius.circular(6), color: Colors.white),
          padding: const EdgeInsets.only(left: 13),
          child: RawKeyboardListener(
            focusNode: _focusNode,
            onKey: (event) {
              if (event.runtimeType == RawKeyDownEvent &&
                  (event.logicalKey.keyId == 54)) {
                setState(() {
                  isShowSuggestMoney = false;
                });
                print(isShowSuggestMoney);
              }
            },
            child: TextFormField(
              controller: _textController,
              autocorrect: true,
              keyboardType: TextInputType.number,
              enableSuggestions: true,
              textInputAction: Platform.isAndroid ? null : TextInputAction.done,
              onChanged: (t) {
                setState(() {
                  t = _textController.text;
                });
              },
              onFieldSubmitted: (value) {
                setState(() {
                  isShowSuggestMoney = false;
                });
                print(isShowSuggestMoney);
              },
              onTap: () {
                setState(() {
                  isShowSuggestMoney = true;
                });

                print(isShowSuggestMoney);
              },
              inputFormatters: <TextInputFormatter>[
                ThousandsFormatter(),
              ],
              decoration: InputDecoration(
                hintText: "Số tiền cần nạp",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixText: "VND",
                suffixIcon: IconButton(
                  onPressed: () => _textController.clear(),
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          color: AppColor.paleGreyFour,
          margin: EdgeInsets.only(left: 21, right: 21, top: 15),
          padding:
              const EdgeInsets.only(left: 11, right: 11, top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  "Tài khoản ngân hàng cần duy trì số dư tối thiểu sau giao dịch là 50.000đ. Vui lòng kiểm tra trước khi thực hiện giao dịch.",
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 21, top: 15, right: 21),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                "Nguồn tiền",
                style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 18,
                ),
              ),
              // Text(
              //   "Biểu phí giao dịch",
              //   style:TextStyle(
              //              fontFamily: 'Montserrat-M',fontSize: 14, color: AppColor.darkSkyBlue),
              // )
            ],
          ),
        ),
        Wrap(
          children: List.generate(topupModel.length ?? 0, (index) {
            return Container(
              child: Column(
                children: <Widget>[
                  _buildChoosePayment(topupModel[index].image,
                      topupModel[index].name, topupModel[index].id),
                ],
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 21, right: 21, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.security),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                    "Mọi thông tin khách hàng dều được mã hoá để bảo mật thông tin khách hàng."),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
        )
      ],
    );
  }

  void _showSnackBar(msg) {
    final snackBar = SnackBar(content: Text(msg));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _buildChoosePayment(String image, String text, int index) {
    return BlocProvider<ChooseTopupEvent, ChooseTopupState, ChooseTopupBloc>(
        bloc: bloc,
        builder: (state) {
          return MaterialButton(
            onPressed: () {
              setState(() {
                state.topupId = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 21, right: 21, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: AppColor.lightPeach,
                        ),
                        child: Image.asset(
                          image,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Miễn phí nạp tiền"),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 21,
                    height: 21,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 3.0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: state.topupId == index
                              ? AppColor.deepBlue
                              : AppColor.lightPeach,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _handlePaymentSuccess(PaymentResponse response) {
    setState(() {
      momoPaymentResult = response;
      print(response.token);
      if (response != null) {}
      // _setState();
    });
    Fluttertoast.showToast(msg: "NẠP TIỀN THÀNH CÔNG: " + response.phonenumber);
  }

  void _handlePaymentError(PaymentResponse response) {
    setState(() {
      momoPaymentResult = response;
      // _setState();
    });
    Fluttertoast.showToast(
        msg: "NẠP TIỀN THẤT BẠI: " + response.message.toString());
  }
}

class SuggestMoneyItem extends StatefulWidget {
  final TextEditingController value;
  final VoidCallback onClick;
  final Function(String) onChange;
  SuggestMoneyItem({this.value, this.onClick, this.onChange});
  @override
  _SuggestMoneyItemState createState() => _SuggestMoneyItemState();
}

class _SuggestMoneyItemState extends State<SuggestMoneyItem> {
  // List<String> suggestDefault = ["100.000", "200.000", "500.000"];
  TextEditingController a;
  @override
  void initState() {
    a = widget.value;
    super.initState();
  }

  // final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: "");
  final currencyFormatter = NumberFormat('#,###,000');

  @override
  Widget build(BuildContext context) {
    var valueOne = a.text.length == 1
        ? "${a.text}0000"
        : a.text.length >= 2 && a.text.length <= 5
            ? "${a.text}000"
            : a.text.length >= 6
                ? "${a.text}0"
                : "100000";
    var valueTwo = a.text.length == 1
        ? "${a.text}00000"
        : a.text.length >= 2 && a.text.length <= 5
            ? "${a.text}0000"
            : a.text.length >= 6
                ? "${a.text}00"
                : "200000";
    var valueThree = a.text.length == 1
        ? "${a.text}000000"
        : a.text.length >= 2 && a.text.length <= 5
            ? "${a.text}00000"
            : a.text.length >= 6
                ? "${a.text}000"
                : "500000";

    return Container(
      padding:
          const EdgeInsets.only(left: 15.0, top: 10, right: 15, bottom: 10),
      color: Colors.white,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.03,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: int.parse(valueOne.replaceAll(',', '')) > 50000000
                    ? Colors.white
                    : Colors.grey[400]),
            child: MaterialButton(
              onPressed: () {
                widget.onClick();
                widget.onChange(valueOne);
              },
              child: Text(
                int.parse(valueOne.replaceAll(',', '')) > 50000000
                    ? ""
                    : "${currencyFormatter.format(int.parse(valueOne.replaceAll(',', '')))}",
                style:
                    TextStyle(fontFamily: 'Montserrat-M', color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.03,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: int.parse(valueTwo.replaceAll(',', '')) > 50000000
                    ? Colors.white
                    : Colors.grey[400]),
            child: MaterialButton(
              onPressed: () {
                widget.onClick();
                widget.onChange(valueTwo);
              },
              child: Text(
                int.parse(valueTwo.replaceAll(',', '')) > 50000000
                    ? ""
                    : "${currencyFormatter.format(int.parse(valueTwo.replaceAll(',', '')))}",
                style:
                    TextStyle(fontFamily: 'Montserrat-M', color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.03,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: int.parse(valueThree.replaceAll(',', '')) > 50000000
                    ? Colors.white
                    : Colors.grey[400]),
            child: MaterialButton(
              onPressed: () {
                widget.onClick();
                widget.onChange(valueThree);
              },
              child: Text(
                int.parse(valueThree.replaceAll(',', '')) > 50000000
                    ? ""
                    : "${currencyFormatter.format(int.parse(valueThree.replaceAll(',', '')))}",
                style:
                    TextStyle(fontFamily: 'Montserrat-M', color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
