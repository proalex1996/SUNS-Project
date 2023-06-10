import 'package:flutter/material.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/medicine/order_medicines.dart';
import 'package:suns_med/src/medicine/provider/medicine_session_bloc.dart';

class DetailOrderMedicine extends StatefulWidget {
  final String id;
  DetailOrderMedicine({@required this.id});

  @override
  _DetailOrderMedicine createState() => _DetailOrderMedicine();
}

class _DetailOrderMedicine extends State<DetailOrderMedicine> {
  final notifyBloc = NotificationBloc();
  final medicineBloc = MedicineBloc();
  int amount = 0;
  @override
  void initState() {
    super.initState();
    //if (medicineBloc?.state?.resultDetailOrder == null) {
    medicineBloc.dispatch(GetDetailOrderEvent(id: this.widget?.id));
    //}
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
        //            fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
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
            amount = state?.resultDetailOrder?.amount ?? 0;
            var items = state?.resultDetailOrder?.items ?? [];
            return Column(children: [
              Container(
                  height: height(context) * 0.65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   color:,

                    // ),
                  ),
                  child: (items != null || items.isNotEmpty)
                      ? ListView.builder(
                          itemCount: items.length ?? 0,
                          itemBuilder: (_, i) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 15, 20, 8),
                                      height: 96,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                15), //or 15.0
                                            child: Container(
                                                height: 85.0,
                                                width: 85.0,
                                                child: items[i]?.image == null
                                                    ? Image.asset(
                                                        'assets/images/logo.png',
                                                        fit: BoxFit.contain,
                                                      )
                                                    : Image.network(
                                                        '${items[i].image}',
                                                        fit: BoxFit.contain,
                                                      )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${items[i]?.name}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat-M',
                                                            fontSize: 16,
                                                            color: AppColor
                                                                .darkPurple,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                    Text(
                                                      'x${items[i]?.quantity ?? 0}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat-M',
                                                          fontSize: 16,
                                                          color: AppColor
                                                              .darkPurple,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  items[i].description != null
                                                      ? '${items[i].description}'
                                                      : '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
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
                                                  items[i].price != null
                                                      ? '${formatCurrency(items[i].price)}đ'
                                                      : '0',
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-M',
                                                      fontSize: 16,
                                                      color: AppColor.deepBlue,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                ],
                              ),
                            );
                          })
                      : Container()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // margin: EdgeInsets.only(top: height(context) * 0.65),
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: height(context) * 0.05,
                      width: width(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: width(context) * 0.05),
                            child: Text(
                              AppLocalizations.of(context).totalAmount,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: AppColor.darkPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(right: width(context) * 0.05),
                            child: Text(
                              amount != null
                                  ? '${formatCurrency(amount)}đ'
                                  : '0',
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                  color: AppColor.deepBlue,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]);
          },
        ),
      ],
    );
  }
}
