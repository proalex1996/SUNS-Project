import 'package:flutter/material.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';
import 'package:suns_med/src/medicine/shoppingcart_medicine.dart';
import 'package:suns_med/src/medicine/medicine.dart';
import 'package:suns_med/src/medicine/dto/medicine_model.dart';
import 'package:suns_med/src/medicine/provider/medicine_session_bloc.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailMedicine extends StatefulWidget {
  final String medicine;
  DetailMedicine({@required this.medicine});

  @override
  _DetailMedicineState createState() => _DetailMedicineState();
}

class _DetailMedicineState extends State<DetailMedicine> {
  final notifyBloc = NotificationBloc();
  int _current = 0;
  int inSearch = 0;
  String name = '';
  int count = 1;
  bool isCheck = false;
  int click = 0;
  final medicineBloc = MedicineBloc();
  @override
  void initState() {
    super.initState();
    if (medicineBloc.state.packageResultMedicine != null) {
      medicineBloc.dispatch(ViewEvent(id: widget?.medicine));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(),
      body: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/orange-appbar.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width(context) * 0.58, height(context) * 0.1, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/orange-appbar.png'),
                          fit: BoxFit.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width(context) * 0.27),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShoppingCartMedicine()),
                        );
                      },
                      child: Stack(children: <Widget>[
                        new IconButton(
                            icon: ImageIcon(
                              AssetImage("assets/images/profile/ic_cart.png"),
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShoppingCartMedicine()),
                              );
                            }),
                        Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: ShoppingCartMedicine.cart.length != 0
                                ? CircleAvatar(
                                    maxRadius: 8,
                                    backgroundColor: AppColor.white,
                                    child: Text(
                                      '${ShoppingCartMedicine.cart.length}',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 8,
                                          color: AppColor.deepBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Container()),
                      ]),
                    ),
                  ),

                  // Expanded(
                  //   child: Padding(
                  //     padding: EdgeInsets.fromLTRB(
                  //         width(context) * 0.2, height(context) * 0.013, 0, 0),
                  //     child: Stack(
                  //       children: [
                  //         IconButton(
                  //             icon: ImageIcon(
                  //               AssetImage("assets/images/profile/ic_cart.png"),
                  //               color: Colors.white,
                  //             ),
                  //             onPressed: () {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => ShoppingCartMedicine()),
                  //               );
                  //             }),
                  //             Positioned(
                  //       top: 0.0,
                  //       right: 0.0,
                  //       child: BlocProvider<NotificationEvent,
                  //           NotificationState, NotificationBloc>(
                  //         bloc: notifyBloc,
                  //         // navigator: (current) => //setState(() {
                  //         //     notifyBloc.dispatch(CountNotifyEvent()),
                  //         // //}),
                  //         builder: (state) {
                  //           return state.countNotify == null ||
                  //                   state.countNotify == 0
                  //               ? Container()
                  //               : CircleAvatar(
                  //                   maxRadius: 8,
                  //                   backgroundColor: AppColor.deepBlue,
                  //                   child: Text(
                  //                     state.countNotify > 99
                  //                         ? "99+"
                  //                         : "${state?.countNotify}",
                  //                     style: TextStyle(
                  //                         fontFamily: 'Montserrat-M',
                  //                         fontSize: 8,
                  //                         color: Colors.white,
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                 );
                  //         },
                  //       ),
                  //     ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            title: BlocProvider<MedicineEvent, MedicineState, MedicineBloc>(
                bloc: medicineBloc,
                builder: (state) {
                  var data = state.resultDetailMedicine;
                  return Text(
                    '${data.name}',
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  );
                }),
            leading: BlocProvider<NotificationEvent, NotificationState,
                NotificationBloc>(
              bloc: notifyBloc,
              builder: (state) {
                return IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      notifyBloc.dispatch(CountNotifyEvent());
                      Navigator.pop(context);
                    });
              },
            ),
            centerTitle: true,
          ),
          body:
              RefreshIndicator(onRefresh: _refreshHome, child: bodyBuilding())),
    );
  }

  Widget bodyBuilding() {
    return BlocProvider<MedicineEvent, MedicineState, MedicineBloc>(
      bloc: medicineBloc,
      builder: (state) {
        var data = state.resultDetailMedicine;

        name = data != null || data.name != null ? data.name : '';
        return data != null
            ? Container(
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
                child: Stack(children: [
                  Container(
                    height: height(context) * 0.6,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Center(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: data.image != null
                                      ? Image.network(
                                          '${data.image}',
                                          fit: BoxFit.cover,
                                          //height: 100,
                                        )
                                      : Image.asset(
                                          'assets/images/logo.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${data.name}',
                                            overflow: TextOverflow.fade,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat-M',
                                                fontSize: 16,
                                                color: AppColor.darkPurple,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            '${data.strengths}',
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
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          rateMe5Start(data.rating ?? 0),
                                          Text(
                                            data.price != null
                                                ? '${formatCurrency(data.price)}'
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
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).description,
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 16,
                                        color: Color(0xFF333333),
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${data.description}',
                                    overflow: TextOverflow.fade,
                                    maxLines: 20,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      fontSize: 14,
                                      color: Color(0xFF000000),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              )
                            ])),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Color(0xFFF2F8FF),
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: GestureDetector(
                        onTap: () {
                          if (click == 0) {
                            setState(() {
                              showToastMessage(
                                  AppLocalizations.of(context).addedCart);
                              ShoppingCartMedicine.cart
                                  .add([data, isCheck, count]);
                            });
                          }
                          click++;

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => ShoppingCartMedicine()),
                          // );
                        },
                        child: Container(
                          height: 50,
                          width: width(context) * 0.9,
                          decoration: BoxDecoration(
                            color: Color(0xFF616C9A),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 10),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context).pickToBuy,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ]))
            : Text(
                'Không có dữ liệu',
                style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 14),
              );
      },
    );
  }

  rateMe5Start(double rating) {
    if (rating != null) {
      if (rating <= 0) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageIcon(
              AssetImage(
                "assets/images/profile/start_default.png",
              ),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
          ],
        );
      } else if (rating > 0 && rating < 1) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.star_half_outlined,
              color: Color(0xFFF8B447),
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
          ],
        );
      } else if (rating == 1) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
          ],
        );
      } else if (rating > 1 && rating < 2) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            Icon(
              Icons.star_half_outlined,
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
          ],
        );
      } else if (rating == 2) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
          ],
        );
      } else if (rating > 2 && rating < 3) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            Icon(
              Icons.star_half_outlined,
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
          ],
        );
      } else if (rating == 3) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
          ],
        );
      } else if (rating > 3 && rating < 4) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            Icon(
              Icons.star_half_outlined,
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
          ],
        );
      } else if (rating == 4) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_default.png"),
              color: Color(0xFF999999),
              size: 18,
            ),
          ],
        );
      } else if (rating > 4 && rating < 5) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            Icon(
              Icons.star_half_outlined,
              color: Color(0xFFF8B447),
            ),
          ],
        );
      } else if (rating >= 5) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
            ImageIcon(
              AssetImage("assets/images/profile/start_rated.png"),
              color: Color(0xFFF8B447),
              size: 18,
            ),
          ],
        );
      }
    }
  }

  Future<Null> _refreshHome() async {
    setState(() {});
  }

  String formatCurrency(int number) {
    if (number != null) {
      final currencyFormatter = NumberFormat('#,###,000');
      String price = currencyFormatter.format(number);
      return price;
    }
    return '0';
  }
}
