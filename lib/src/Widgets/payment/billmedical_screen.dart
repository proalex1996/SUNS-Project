import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/equipment/dto/equipment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/dto/order_model.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/payment/ordersuccess_screen.dart';
import 'package:html/dom.dart' as dom;
import 'package:suns_med/src/Widgets/payment/payments_screen.dart';
import 'package:suns_med/src/Widgets/payment/session_bill_order_bloc.dart';
import 'package:suns_med/src/Widgets/payment/session_choosepayment_bloc.dart';
import 'package:suns_med/src/Widgets/payment/session_payment_bloc.dart';
import 'package:suns_med/src/Widgets/payment/web_view_screen.dart';

class BillMedicalScreen extends StatefulWidget {
  final EquipmentModel medicalModel;
  final int doctorId;
  const BillMedicalScreen({
    Key key,
    this.doctorId,
    this.medicalModel,
  }) : super(key: key);
  @override
  _BillMedicalScreenState createState() => _BillMedicalScreenState();
}

class _BillMedicalScreenState extends State<BillMedicalScreen> {
  final money = NumberFormat('#,###,000');
  final doctorBloc = DetailItemBloc();
  final sessionBloc = SessionBloc();
  final choosePaymentBloc = ChoosePaymentBloc();
  final paymentBloc = PaymentBloc();
  final billOrderBloc = BillOrderBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // paymentBloc.dispatch(EventResetState());
    // paymentBloc.dispatch(EventResetStateVnPay());
    billOrderBloc.dispatch(EventGetOrder());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider<BillOrderEvent, BillOrderState, BillOrderBloc>(
          bloc: billOrderBloc,
          // navigator: (billOrderState) {
          //   if (billOrderState.state.orderPay == true) {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => OrderSuccessScreen(
          //           orderNo: billOrderState.orderModelNew.code,
          //         ),
          //       ),
          //     );
          //   }
          // },

          builder: (billOrderState) {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppColor.whitetwo,
              appBar: AppBar(
                backgroundColor: Color(0xFFF47A4D),
                centerTitle: true,
                title: Text(
                  'Phiếu thanh toán ${billOrderState.orderModelNew?.code}'
                      .substring(0, 17),
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _builRowInforBill(
                        billOrderState.orderModelNew?.code ?? "",
                        DateTime.parse(
                            billOrderState.orderModelNew?.createdTime ??
                                "2021-01-27T07:11:40.316Z")),
                    _buildRowPRoduct(billOrderState.orderModelNew?.items ?? []),
                    _buildRowTotal(
                            billOrderState.orderModelNew?.amount?.toDouble() ??
                                0,
                            billOrderState.orderModelNew?.amount?.toDouble()) ??
                        0,
                    _buildRowChoosePayment(),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 18, bottom: 42),
                      child: Text(
                        'Chờ thanh toán...',
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 15,
                          color: AppColor.deepBlue,
                        ),
                      ),
                    ),
                    _buildButton(billOrderState),
                  ],
                ),
              ),
            );
          }),
    );
  }

  _builRowInforBill(String orderNo, DateTime dateTime) {
    return Container(
      margin: EdgeInsets.only(top: 11, bottom: 10),
      height: 124,
      color: Colors.white,
      child: Container(
        padding:
            const EdgeInsets.only(left: 33, right: 30, bottom: 18, top: 19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Thông tin phiếu thanh toán',
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 15,
                  color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Mã thanh toán',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 15,
                      color: Color(0xff515151)),
                ),
                Container(
                  alignment: Alignment.center,
                  // width: 130,
                  // height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xffdedbf2)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      orderNo,
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Ngày lập phiếu',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 15,
                      color: Color(0xff515151)),
                ),
                Text(
                  DateFormat.yMd('vi').format(dateTime),
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 15),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildRowPRoduct(List<Items> items) {
    return Wrap(
      children: List.generate(items.length, (index) {
        var data = items[index];
        return Container(
          alignment: Alignment.center,
          color: Colors.white,
          height: 145,
          child: Container(
            height: 109,
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.whitetwo),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 12, left: 7),
                  child: Image.network(
                    data.image,
                    width: 99,
                    fit: BoxFit.cover,
                    height: 87,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 212,
                      padding:
                          const EdgeInsets.only(top: 12, right: 7, left: 10),
                      child: Text(
                        data.name,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 212,
                      padding:
                          const EdgeInsets.only(top: 10, right: 7, left: 10),
                      child: Html(
                        data: data?.description?.substring(0, 80),

                        defaultTextStyle: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 13,
                            color: Colors.black),

                        // padding: EdgeInsets.all(10.0),
                        onLinkTap: (url) {
                          print("Opening $url...");
                        },
                        customRender: (node, children) {
                          if (node is dom.Element) {
                            switch (node.localName) {
                              case "custom_tag": // using this, you can handle custom tags in your HTML
                                return Column(children: children);
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  _buildRowTotal(double price, double priceTemp) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 12),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 16, top: 22, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Tạm tính',
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 15,
                    color: AppColor.greyishBrown,
                  ),
                ),
                Text(
                  "${money.format(priceTemp)}đ",
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 23,
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 10.5, left: 16, right: 17, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  'assets/images/ic_price.png',
                  width: 26,
                  height: 26,
                ),
                Text(
                  'Tổng thanh toán',
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                ),
                SizedBox(
                  width: 19.8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "${money.format(price)}đ",
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 20,
                              color: AppColor.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Đã bao gồm VAT',
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          color: AppColor.greyishBrown,
                          fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildRowChoosePayment() {
    return BlocProvider<ChoosePaymentEvent, ChoosePaymentState,
            ChoosePaymentBloc>(
        bloc: choosePaymentBloc,
        navigator: (state) {},
        builder: (state) {
          return Container(
            color: Colors.white,
            padding:
                const EdgeInsets.only(top: 33, bottom: 47, left: 16, right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentsScreen(
                        // orderResult: this.widget.orderResult,
                        // detailService: this.widget.detailService,
                        ),
                  ),
                );
              },
              child: state.paymentId == 2
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/ic_price.png',
                          width: 26,
                          height: 26,
                        ),
                        Container(
                          width: 100,
                          child: Text(
                            'Phương thức thanh toán',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: Text(
                            'Thanh toán bằng VNPay',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 15),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: AppColor.lightPeach,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: AppColor.lightPeach,
                            ),
                            child: Image.asset(
                              "assets/images/logo_vnpay.png",
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/ic_daulon.png',
                          width: 7,
                          height: 13,
                        ),
                      ],
                    )
                  : state.paymentId == 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/ic_price.png',
                              width: 26,
                              height: 26,
                            ),
                            Container(
                              width: 100,
                              child: Text(
                                'Phương thức thanh toán',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M', fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 150,
                              child: Text(
                                'Thanh toán bằng Momo',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M', fontSize: 15),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: AppColor.lightPeach,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppColor.lightPeach,
                                ),
                                child: Image.asset(
                                  "assets/images/ic_momo.png",
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/ic_daulon.png',
                              width: 7,
                              height: 13,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/ic_price.png',
                              width: 26,
                              height: 26,
                            ),
                            Container(
                              width: 100,
                              child: Text(
                                'Phương thức thanh toán',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M', fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 150,
                              child: Text(
                                'Thanh toán bằng số dư trong ví của app',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M', fontSize: 15),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: AppColor.lightPeach,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppColor.lightPeach,
                                ),
                                child: Image.asset(
                                  "assets/images/ic_wallet.png",
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/ic_daulon.png',
                              width: 7,
                              height: 13,
                            ),
                          ],
                        ),
            ),
          );
        });
  }

  Future _showAlert(BuildContext context, String message) async {
    return showDialog(
      context: context,
      useRootNavigator: true,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: AppColor.white,
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Text(
                  'Thông báo',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Số tiền trong Ví không đủ để thực hiện giao dịch. Vui lòng chọn phương thức thanh toán khác.',
                    maxLines: 3,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      color: AppColor.battleshipGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
                Divider(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: RouteSettings(name: "/Page1"),
                            builder: (context) => PaymentsScreen(
                                // detailService: this.widget.detailService,
                                ),
                          ),
                        );
                      },
                      child: Text(
                        'Chọn phương thức khác',
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 16,
                            color: AppColor.deepBlue),
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Đóng',
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildButton(BillOrderState billOrderState) {
    return BlocProvider<ChoosePaymentEvent, ChoosePaymentState,
        ChoosePaymentBloc>(
      bloc: choosePaymentBloc,
      builder: (choosePaymentState) {
        return BlocProvider<DetailItemEvent, DetailItemState, DetailItemBloc>(
          bloc: doctorBloc,
          builder: (doctorState) {
            return BlocProvider<PaymentEvent, PaymentState, PaymentBloc>(
                bloc: paymentBloc,
                navigator: (statePayment) {
                  if (statePayment.checkPayment == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => WebViewExample(
                                  userName: sessionBloc.state.user.phoneNumber,
                                  orderNo:
                                      billOrderState.orderModelNew?.code ?? "",
                                  price: billOrderState.orderModelNew?.amount
                                          ?.toDouble() ??
                                      0,
                                  // confirmState.orderModelNew?.code ?? "",
                                  // confirmState.orderModelNew?.amount ?? 0
                                )));
                  }
                  if (statePayment.paid == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSuccessScreen(
                          orderNo: billOrderState.orderModelNew.code,
                        ),
                      ),
                    );
                  }
                },
                builder: (statePayment) {
                  return Container(
                    padding:
                        const EdgeInsets.only(bottom: 14, left: 31, right: 31),
                    child: CustomButton(
                      color: AppColor.deepBlue,
                      onPressed: () async {
                        if (choosePaymentState.paymentId == 0) {
                          if (billOrderState.checkBalance == true) {
                            // confirmBloc
                            //     .dispatch(EventPaymentOrder(paymentMethod: 1));
                          } else {
                            await _showAlert(context, 'message');
                          }
                        } else if (choosePaymentState.paymentId == 1) {
                          // confirmBloc.dispatch(EventPaymentMethodMomo(
                          //     orderResult: confirmBloc.state.orderModelNew));
                          // confirmBloc.dispatch(
                          //     EventPaymentOrder(paymentMethod: 2));
                        } else if (choosePaymentState.paymentId == 2) {
                          // confirmBloc.dispatch(EventPaymentMethodVNPay(
                          //     orderResult: confirmBloc.state.orderModelNew));
                        }
                      },
                      radius: BorderRadius.circular(26),
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: Colors.white),
                      text: 'Thanh toán',
                    ),
                  );
                });
          },
        );
      },
    );
  }
}
