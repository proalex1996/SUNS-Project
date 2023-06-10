import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';
import 'package:suns_med/src/medicine/dto/place_order_model.dart';
import 'adress_medicine.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingCartMedicine extends StatefulWidget {
  static List cart = [];
  ShoppingCartMedicine({Key key}) : super(key: key);
  @override
  _ShoppingCartMedicine createState() => _ShoppingCartMedicine();
}

class _ShoppingCartMedicine extends State<ShoppingCartMedicine> {
  final notifyBloc = NotificationBloc();
  int _current = 0;
  int inSearch = 0;
  List _cart = [];
  int value = 0;
  int totalCount = 0;
  var listOrder = [];

  bool isChecked = false;
  void initState() {
    super.initState();
    _refreshHome();
    _cart = ShoppingCartMedicine.cart;
    for (int i = 0; i < _cart.length; i++)
      if (isChecked) totalCount = _cart[i].first.price + totalCount;
  }

  remove(List item) {
    for (int i = 0; i < item.length; i++) {
      if (item[i][1] == true) {
        totalCount = totalCount - (item[i][0].price * item[i].last);
      }
    }
    item.removeWhere((element) => element[1] == true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(),
      body: Scaffold(
          appBar: AppBar(
            toolbarHeight: height(context) * 0.13,
            backgroundColor: AppColor.deepBlue,
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
                          image: AssetImage(
                              'assets/images/profile/pattern_part_circle.png'),
                          fit: BoxFit.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          width(context) * 0.2, height(context) * 0.01, 0, 0),
                      child: IconButton(
                          icon: ImageIcon(
                            AssetImage(
                                "assets/images/profile/ic_trash_bin.png"),
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              remove(_cart);
                            });
                            showToastMessage(
                                AppLocalizations.of(context).cartRemove);
                          }),
                    ),
                  )
                ],
              ),
            ),
            title: Text(
              AppLocalizations.of(context).cart,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 18,
                  color: Colors.white),
            ),
            leading: BlocProvider<NotificationEvent, NotificationState,
                NotificationBloc>(
              bloc: notifyBloc,
              builder: (state) {
                return IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      notifyBloc.dispatch(CountNotifyEvent());
                      Navigator.pop(context);
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

  Future<Null> _refreshHome() async {
    setState(() {});
  }

  Widget bodyBuilding() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.white, Colors.white54, Color(0xFFF2F8FF)],
            ),
          ),
          child: ListView.builder(
            itemCount: _cart.length,
            itemBuilder: (_, i) {
              return Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Color(0xFF438BA7),
                        //fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: _cart[i][1],
                        onChanged: (bool value) {
                          setState(() {
                            if (value) {
                              totalCount = totalCount +
                                  (_cart[i].first.price * _cart[i].last);
                            } else {
                              if (totalCount >= 0)
                                totalCount = totalCount -
                                    (_cart[i].first.price * _cart[i].last);
                            }
                            _cart[i][1] = value;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 10),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(5), //or 15.0
                                child: Container(
                                  height: 85.0,
                                  width: 85.0,
                                  child: _cart[i].first.image != null
                                      ? Image.network(
                                          '${_cart[i].first.image}',
                                          fit: BoxFit.contain,
                                          //height: 100,
                                        )
                                      : Image.asset(
                                          'assets/images/logo.png',
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_cart[i].first.name}',
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
                                      '${_cart[i].first.strengths}',
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 13,
                                        color:
                                            Color(0xFF2E3E5C).withOpacity(0.5),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${formatCurrency(_cart[i].first.price)}',
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
                              Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Color(0xFFF2F2F2),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (_cart[i].last > 0) {
                                            if (_cart[i][1]) {
                                              _cart[i].last--;
                                              totalCount = totalCount -
                                                  _cart[i].first.price;
                                              // if (totalCount >= 0) {
                                              //   totalCount = totalCount -
                                              //       _cart[i].first.price;
                                              // }
                                            } else if (_cart[i].last == 0) {
                                              totalCount = totalCount -
                                                  _cart[i].first.price;
                                              _cart.remove(_cart[i]);
                                            }
                                          }
                                        });
                                      }),
                                  Text(
                                    '${_cart[i].last}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 16,
                                        color: AppColor.darkPurple,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Color(0xFFC4C4C4),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (_cart[i][1]) {
                                            _cart[i].last++;
                                            totalCount = _cart[i].first.price +
                                                totalCount;
                                          }
                                        });
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: height(context) * 0.2,
            color: Color(0xFFF2F8FF),
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: width(context) * 0.05),
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
                      padding: EdgeInsets.only(right: width(context) * 0.05),
                      child: Text(
                        totalCount > 0
                            ? '${formatCurrency(totalCount)}đ'
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    for (int i = 0; i < _cart.length; i++) {
                      if (_cart[i][1] == true) {
                        listOrder.add(_cart[i]);
                      }
                    }
                    totalCount > 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdressMedicine(
                                      listCart: listOrder,
                                    )),
                          )
                        : showToastMessage('Vui lòng chọn số lượng hợp lệ');
                  },
                  child: Container(
                    height: height(context) * 0.08,
                    width: width(context),
                    decoration: BoxDecoration(
                      color: totalCount > 0 || !(_cart.indexOf(true) == -1)
                          ? Color(0xFF616C9A)
                          : Color(0xFFE0E0E0),
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
              ],
            ),
          ),
        )
      ]),
    );
  }

  String formatCurrency(int number) {
    if (number != null) {
      final currencyFormatter = NumberFormat('#,###,000');
      String price = currencyFormatter.format(number);
      return price;
    }
    return '0đ';
  }
}
