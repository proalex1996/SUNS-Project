import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/order_result.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/dto/detail_service_model.dart';
import 'package:suns_med/src/Widgets/payment/choose_payment_model.dart';
import 'package:suns_med/src/Widgets/payment/session_choosepayment_bloc.dart';
import 'package:suns_med/src/order/session_confirminfo_bloc.dart';

class PaymentsScreen extends StatefulWidget {
  final OrderResult orderResult;
  final DetailServiceModel detailService;
  PaymentsScreen({this.orderResult, this.detailService});
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final bloc = ChoosePaymentBloc();
  final paymentBloc = ConfirmBloc();
  int selected;
  @override
  void initState() {
    bloc.dispatch(EventPayment(id: bloc.state.paymentId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        centerTitle: true,
        title: Text(
          'Chọn hình thức thanh toán',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
      ),
      body: Wrap(
        children: List.generate(paymentModel.length ?? 0, (index) {
          return Container(
            padding: const EdgeInsets.only(left: 27, right: 15, top: 23),
            child: Column(
              children: <Widget>[
                _buildChoosePayment(paymentModel[index].image,
                    paymentModel[index].name, paymentModel[index].id),
                Divider(
                  height: 33,
                  thickness: 1.5,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  _buildChoosePayment(String image, String text, int index) {
    return BlocProvider<ChoosePaymentEvent, ChoosePaymentState,
            ChoosePaymentBloc>(
        bloc: bloc,
        builder: (state) {
          return BlocProvider<ConfirmEvent, ConfirmState, ConfirmBloc>(
            bloc: paymentBloc,
            builder: (paymentState) {
              return InkWell(
                onTap: () {
                  setState(() {
                    state.paymentId = index;
                  });
                  bloc.dispatch(EventPayment(id: index));
                  Navigator.of(context).pop();
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (ctx) => BillOrderScreen(
                  //       // orderResult: paymentState.result,
                  //       detailService: this.widget.detailService,
                  //     ),
                  //   ),
                  // );
                  // Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Container(
                      width: 240,
                      child: Text(
                        text,
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: Color(0xff515151),
                        ),
                      ),
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
                            color: state.paymentId == index
                                ? AppColor.deepBlue
                                : AppColor.lightPeach,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
