import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/medicine/detail_order_medicine.dart';
import 'package:suns_med/src/medicine/provider/medicine_session_bloc.dart';

class OrderMedicine extends StatefulWidget {
  OrderMedicine({Key key}) : super(key: key);

  @override
  _OrderMedicine createState() => _OrderMedicine();
}

class _OrderMedicine extends State<OrderMedicine> {
  final notifyBloc = NotificationBloc();
  final medicineBloc = MedicineBloc();
  ScrollController controller;
  @override
  void initState() {
    super.initState();
    if (medicineBloc.state.packageResultOrder != null) {
      medicineBloc.dispatch(GetOrderEvent());
    }

    controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter < 50) {
      setState(() {
        medicineBloc.dispatch(GetOrderEvent());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: height(context) * 0.15,
        //   backgroundColor: AppColor.deepBlue,
        //   flexibleSpace: Padding(
        //     padding: EdgeInsets.fromLTRB(
        //         width(context) * 0.58, height(context) * 0.1, 0, 0),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage(
        //               'assets/images/profile/pattern_part_circle.png'),
        //           fit: BoxFit.none,
        //         ),
        //       ),
        //     ),
        //   ),
        //   title: Text(
        //     'Đơn hàng của tôi',
        //     style:TextStyle(
        //                           fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
        //   ),
        //   leading: BlocProvider<NotificationEvent, NotificationState,
        //       NotificationBloc>(
        //     bloc: notifyBloc,
        //     builder: (state) {
        //       return IconButton(
        //           icon: Icon(Icons.arrow_back),
        //           onPressed: () {
        //             notifyBloc.dispatch(CountNotifyEvent());
        //             Navigator.pop(context);
        //           });
        //     },
        //   ),
        //   centerTitle: true,
        // ),
        appBar: const TopAppBar(),
        body: bodyBuilding());
  }

  Widget bodyBuilding() {
    return Column(
      children: [
        CustomAppBar(
          title: AppLocalizations.of(context).myOrders,
          titleSize: 18,
        ),
        BlocProvider<MedicineEvent, MedicineState, MedicineBloc>(
            bloc: medicineBloc,
            builder: (state) {
              var order = state.packageResultOrder.data;
              return Container(
                  height: height(context) * 0.75,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.white,
                        Colors.white54,
                        Color(0xFFF2F8FF)
                      ],
                    ),
                  ),
                  child: order != null
                      ? ListView.builder(
                          controller: controller,
                          // physics: NeverScrollableScrollPhysics(),
                          // shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: order.length,
                          itemBuilder: (_, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailOrderMedicine(
                                      id: order[i].id,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 8, 25, 8),
                                child: Container(
                                  height: 94,
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 26,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Đơn hàng #${order[i].code}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat-M',
                                                  fontSize: 16,
                                                  color: AppColor.darkPurple,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${formatDate(order[i].createdTime)}',
                                              overflow: TextOverflow.fade,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontFamily: 'Montserrat-M',
                                                fontSize: 13,
                                                color: Color(0xFF2E3E5C)
                                                    .withOpacity(0.5),
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              order[i].amount != 0
                                                  ? '${formatCurrency(order[i].amount)}đ'
                                                  : '0đ',
                                              overflow: TextOverflow.fade,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat-M',
                                                  fontSize: 16,
                                                  color: AppColor.deepBlue,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : Container());
            }),
      ],
    );
  }

  formatDate(String datetime) {
    DateTime todayDate = DateTime.parse(datetime);
    String date = DateFormat('dd/MM/yyyy').format(todayDate).toString();
    String time = DateFormat('HH:mm').format(todayDate).toString();
    return time + ', ' + date;
  }
}

String formatCurrency(int number) {
  if (number != null) {
    final currencyFormatter = NumberFormat('#,###,000');
    String price = currencyFormatter.format(number);
    return price;
  }
  return '0';
}
