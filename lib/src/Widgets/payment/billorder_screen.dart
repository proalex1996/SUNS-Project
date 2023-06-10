import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/equipment/dto/equipment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/dto/order_model.dart';
import 'package:suns_med/src/Widgets/Bottombar/navigator_bar.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/payment/ordersuccess_screen.dart';
import 'package:suns_med/src/Widgets/payment/session_bill_order_bloc.dart';
import 'package:suns_med/src/Widgets/payment/session_choosepayment_bloc.dart';
import 'package:suns_med/src/Widgets/payment/session_payment_bloc.dart';
import 'package:suns_med/src/order/session_confirminfo_bloc.dart';
import 'package:html/dom.dart' as dom;
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/products.dart';

class BillOrderScreen extends StatefulWidget {
  final EquipmentModel medicalModel;
  final int doctorId;
  final String appointmentId;
  final String idOrder;
  const BillOrderScreen({
    Key key,
    this.doctorId,
    this.medicalModel,
    this.appointmentId,
    this.idOrder,
  }) : super(key: key);
  @override
  _BillOrderScreenState createState() => _BillOrderScreenState();
}

class _BillOrderScreenState extends State<BillOrderScreen> {
  final money = NumberFormat('#,###,000');
  final doctorBloc = DetailItemBloc();
  final sessionBloc = SessionBloc();
  final choosePaymentBloc = ChoosePaymentBloc();
  final billOrderBloc = BillOrderBloc();
  final paymentBloc = PaymentBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final bloc = ConfirmBloc();

  @override
  void initState() {
    // paymentBloc.dispatch(EventResetState());
    // paymentBloc.dispatch(EventResetStateVnPay());
    // confirmBloc.dispatch(EventResetStatePaymentMethodVnPay());
    if (widget.idOrder != null) {
      billOrderBloc.dispatch(EventGetOrder(orderId: this.widget.idOrder));
    } else {
      billOrderBloc
          .dispatch(EventGetOrder(orderId: bloc.state.orderModelNew.id));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _showAlert(context, 'message'),
      child: BlocProvider<BillOrderEvent, BillOrderState, BillOrderBloc>(
          bloc: billOrderBloc,
          // navigator: (confirmState) {
          //   if (confirmBloc.state.orderPay == true) {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => OrderSuccessScreen(
          //           // orderNo: confirmBloc.state.orderModelNew.code,
          //         ),
          //       ),
          //     );
          //   }
          // },
          builder: (billOrderState) {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppColor.white,
              appBar: const TopAppBar(),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CustomAppBar(
                      title: AppLocalizations.of(context).paymentSlip,
                      titleSize: 18,
                      hasBackButton: true,
                    ),
                    _builRowInforBill(
                        billOrderState.orderModelNew?.code ?? "",
                        DateTime.parse(
                            billOrderState.orderModelNew?.createdTime ??
                                "2021-01-27T07:11:40.316Z")),
                    _buildRowPRoduct(billOrderState.orderModelNew?.items ?? []),
                    _buildRowTotal(billOrderState.orderModelNew?.amount ?? 0,
                        billOrderState.orderModelNew?.amount ?? 0),
                    //_buildRowChoosePayment(),
                    // Container(
                    //   alignment: Alignment.center,
                    //   margin: EdgeInsets.only(top: 18, bottom: 10),
                    //   child: Text(
                    //     'Chờ xác nhận...',
                    //     style:TextStyle(
                    //                 fontFamily: 'Montserrat-M',
                    //       fontSize: 15,
                    //       color: AppColor.deepBlue,
                    //     ),
                    //   ),
                    // ),
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
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColor.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 23),
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            height: 35,
            child: Text(
              AppLocalizations.of(context).paymentInfor,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.darkPurple),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              orderNo,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.darkPurple),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(4),
            ),
            margin: EdgeInsets.all(10),
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            alignment: Alignment.centerLeft,
            height: 66,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).dateOfVote,
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.veryLightPinkTwo),
                    )),
                SizedBox(
                  height: 4,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat.Hm('vi').format(dateTime) +
                          ' ' +
                          DateFormat.yMd('vi').format(dateTime),
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.darkPurple),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildRowPRoduct(List<Items> items) {
    return Wrap(
      children: List.generate(items.length, (index) {
        var data = items[index];
        return ProductItem(
            isButton: false,
            showPrice: false,
            genderN: data?.gender,
            fromAge: data?.fromAge,
            toAge: data?.toAge,
            description: data?.description,
            exam: data?.exam,
            title: data?.name,
            image: data?.image,
            price: data?.price?.toDouble(),
            press: () {},
            test: data?.test);
      }),
    );
  }

  _buildRowTotal(int price, int priceTemp) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColor.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
            margin: EdgeInsets.all(10),
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            height: 35,
            child: Text(
              AppLocalizations.of(context).payment,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.darkPurple),
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).temporary,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            //fontWeight: FontWeight.bold,
                            color: AppColor.darkPurple),
                      ),
                      Text(
                        "${money.format(priceTemp)} đ",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darkPurple),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).totalPayment,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            //fontWeight: FontWeight.bold,
                            color: AppColor.darkPurple),
                      ),
                      Text(
                        "${money.format(price)} đ",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.orangeColor),
                      ),
                    ],
                  )
                ],
              )),
          Container(
              decoration: BoxDecoration(
                color: AppColor.lightGray,
                borderRadius: BorderRadius.circular(4),
              ),
              margin: EdgeInsets.all(10),
              padding: const EdgeInsets.only(
                  left: 10, top: 10, bottom: 10, right: 23),
              alignment: Alignment.centerLeft,
              height: 66,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context).paymentMethod,
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColor.warmGrey,
                            ),
                          )),
                      SizedBox(
                        height: 4,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context).payByCash,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColor.darkPurple),
                          ))
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 16,
                    color: Colors.black,
                  )
                ],
              ))
        ],
      ),
    );
  }
  //   Container(
  //     margin: EdgeInsets.only(top: 10, bottom: 12),
  //     color: Colors.white,
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           padding: const EdgeInsets.only(left: 16, top: 22, right: 16),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Text(
  //                 'Tạm tính',
  //                 style:TextStyle(
  //                fontFamily: 'Montserrat-M',
  //                   fontSize: 15,
  //                   color: AppColor.greyishBrown,
  //                 ),
  //               ),
  //               Text(
  //                 "${money.format(priceTemp)}đ",
  //                 style:TextStyle(
  //               fontFamily: 'Montserrat-M',
  //                   fontSize: 15,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Divider(
  //           height: 23,
  //           thickness: 1.5,
  //           indent: 20,
  //           endIndent: 20,
  //         ),
  //         Container(
  //           padding: const EdgeInsets.only(
  //               top: 10.5, left: 16, right: 17, bottom: 16),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Row(
  //                 children: [
  //                   Image.asset(
  //                     'assets/images/ic_price.png',
  //                     width: 26,
  //                     height: 26,
  //                   ),
  //                   SizedBox(
  //                     width: 20,
  //                   ),
  //                   Text(
  //                     'Tổng thanh toán',
  //                     style:TextStyle(
  //                  fontFamily: 'Montserrat-M',fontSize: 16),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 width: 19.8,
  //               ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: <Widget>[
  //                   Row(
  //                     children: [
  //                       Text(
  //                         "${money.format(price)}đ",
  //                         style:TextStyle(
  //                                   fontFamily: 'Montserrat-M',
  //                             fontSize: 20,
  //                             color: AppColor.red,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 7,
  //                   ),
  //                   Text(
  //                     'Đã bao gồm VAT',
  //                     style:
  //                        TextStyle(
  //                                    fontFamily: 'Montserrat-M',color: AppColor.greyishBrown, fontSize: 13),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _buildRowChoosePayment() {
    return BlocProvider<ChoosePaymentEvent, ChoosePaymentState,
            ChoosePaymentBloc>(
        bloc: choosePaymentBloc,
        builder: (state) {
          return Container(
            color: Colors.white,
            padding:
                const EdgeInsets.only(top: 33, bottom: 47, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_price.png',
                      width: 26,
                      height: 26,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        'Phương thức thanh toán',
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 150,
                      child: Text(
                        "Thanh toán bằng tiền mặt",
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      width: 10,
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
                          "assets/images/ic_money.png",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
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
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: AppColor.white,
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    widget.appointmentId == null
                        ? 'Bạn chưa thanh toán hoá đơn, cần thanh toán để hoàn tất giao dịch.'
                        : 'Bạn chưa thanh toán hoá đơn, cần thanh toán để hoàn tất đặt lịch!',
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      color: AppColor.battleshipGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      widget.appointmentId == null
                          ? "*Ấn huỷ bỏ để trở về trang chủ."
                          : '*Lưu ý: Nếu ấn huỷ bỏ thì đơn đặt lịch vẫn được ghi nhận với trạng thái chờ xác nhận.',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 13),
                      maxLines: 5,
                    ),
                  ),
                ),
                Divider(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomBar()),
                            (route) => true);
                      },
                      child: Text(
                        'Huỷ bỏ',
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Tiếp tục',
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 16,
                            color: AppColor.deepBlue),
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
                  if (statePayment.orderPay == true) {
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
                      color: AppColor.purple,
                      onPressed: () {
                        paymentBloc.dispatch(EventPaymentOrder(
                            paymentMethod: 8, orderId: widget.idOrder));
                      },
                      radius: BorderRadius.circular(40),
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: Colors.white),
                      text: 'Xác nhận',
                    ),
                  );
                });
          },
        );
      },
    );
  }
}
