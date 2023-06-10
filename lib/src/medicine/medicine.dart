import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/app_config.dart';
import 'package:suns_med/src/medicine/dto/medicine_model.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';
import 'package:suns_med/src/medicine/provider/medicine_session_bloc.dart';
import 'package:suns_med/src/medicine/shoppingcart_medicine.dart';
import 'detail_medicine.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Medicine extends StatefulWidget {
  Medicine({Key key}) : super(key: key);

  @override
  _MedicineState createState() => _MedicineState();
}

class _MedicineState extends State<Medicine> {
  final notifyBloc = NotificationBloc();
  TextEditingController controller = TextEditingController();
  final medicineBloc = MedicineBloc();
  bool imgCheck = false;
  int _current = 0;
  int inSearch = 0;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    if (medicineBloc.state.packageResultMedicine != null) {
      medicineBloc.dispatch(LoadEvent());
      // setState(() {
      //   isLoading = true;
      // });
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        medicineBloc.dispatch(LoadEvent());
      }
    });
  }

  Future getResultMedicine(String key) {
    medicineBloc.dispatch(SearchEvent(key: key));
  }

  @override
  Widget build(BuildContext context) {
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
        //     'Nhà Thuốc Gcare',
        //     style:TextStyle(
        //          fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
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
        body: Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
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
                            image:
                                AssetImage('assets/images/orange-appbar.png'),
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
                  ],
                ),
              ),
              title: BlocProvider<MedicineEvent, MedicineState, MedicineBloc>(
                  bloc: medicineBloc,
                  builder: (state) {
                    var data = state.resultDetailMedicine;
                    return Text(
                      AppLocalizations.of(context).gcarePharmacy,
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
            body: RefreshIndicator(
                onRefresh: _refreshHome, child: bodyBuilding())));
  }

  Future<Null> _refreshHome() async {
    setState(() {
      // medicineBloc.dispatch(LoadEvent());
    });
  }

  Widget bodyBuilding() {
    final CarouselController _controller = CarouselController();
    return BlocProvider<MedicineEvent, MedicineState, MedicineBloc>(
        bloc: medicineBloc,
        builder: (state) {
          var data = state.packageResultMedicine.data;
          return data != null
              ? Container(
                  decoration: BoxDecoration(color: Color(0xFFFfFfFF)
                      // gradient: LinearGradient(
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      //   colors: <Color>[Color(0xFFF2F8FF)],
                      // ),
                      ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        // CustomAppBar(
                        //   title: AppLocalizations.of(context).gcarePharmacy,
                        //   titleSize: 18,
                        // ),
                        Padding(
                          padding: EdgeInsets.only(top: height(context) * 0.03),
                          child: carousel(context, _controller, data),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        StickyHeader(
                          header: searchBar(),
                          content: state.packageResultMedicine != null
                              ? listMedicine(data)
                              : AppConfig().loading,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )
              : AppConfig().loading;
        });
  }

  convertListtoP(List imgList) {
    final List<Widget> imageSliders = imgList
        .map((item) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailMedicine(
                            medicine: item.id,
                          )),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  item.image,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ))
        .toList();
    return imageSliders;
  }

  Widget carousel(BuildContext context, CarouselController _controller, data) {
    List imgList = [];
    List<Widget> imageSliders = [];
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null) {
          if (data[i].image != null) {
            if (i <= 3) {
              imgList.add(data[i]);
            } else {
              break;
            }
          }
        }
      }
    }
    if (imgList != []) {
      imageSliders = convertListtoP(imgList);
    }
    if (imageSliders.isNotEmpty) {
      return Column(children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              height: height(context) * 0.25,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return Container(
              width: _current == entry.key ? 13 : 8,
              height: _current == entry.key ? 13 : 8,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : AppColor.darkPurple)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            );
          }).toList(),
        ),
      ]);
    } else {
      return Container();
    }
  }

  Widget searchBar() {
    return Container(
      color: Color(0xFFFFFFFF),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            width(context) * 0.07, 10, width(context) * 0.07, 20),
        child: Container(
            height: height(context) * 0.08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFF2F2F2),
              // boxShadow: [
              //   BoxShadow(color: Colors.green, spreadRadius: 3),
              // ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        icon: ImageIcon(
                          AssetImage("assets/images/profile/ic_search.png"),
                          color: Color(0xFF999999),
                          size: 18,
                        ),
                        // hintText: 'What do people call you?',
                        hintText: AppLocalizations.of(context).findMedicine,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hasFloatingPlaceholder: false),
                    onSaved: (String value) {
                      controller.text = value;
                      return controller.text;
                    },
                    onFieldSubmitted: (String value) {
                      inSearch = 1;
                      controller.text = value;
                      getResultMedicine(value);
                    },
                    validator: (String value) {
                      return (value != null && value.contains('@'))
                          ? 'Do not use the @ char.'
                          : null;
                    },
                  )),
            )),
      ),
    );
  }

  Widget listMedicine(data) {
    List<MedicineModel> right = [];
    List<MedicineModel> left = [];
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        if (i / 2 != 0) {
          right.add(data[i]);
        } else {
          left.add(data[i]);
        }
      }
    }

    return Column(
      children: [
        data != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(
                    width(context) * 0.05, 0, width(context) * 0.05, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            for (int i = 0; i < right.length; i++)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailMedicine(
                                              medicine: right[i].id,
                                            )),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 10),
                                          ],
                                        ),
                                        height: 180,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: right[i].image != null
                                                  ? Image.network(
                                                      '${right[i].image}',
                                                      width:
                                                          width(context) * 0.35,
                                                      height: 90,
                                                      fit: BoxFit.scaleDown,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/logo.png',
                                                      width: isTablet(context)
                                                          ? width(context) *
                                                              0.35
                                                          : width(context) *
                                                              0.35,
                                                      height: isTablet(
                                                                  context) ==
                                                              false
                                                          ? height(context) *
                                                              0.07
                                                          : height(context) *
                                                              0.1,
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${right[i].name}',
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
                                              '${right[i].strengths}',
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
                                            Text(
                                              '${formatCurrency(right[i].price)}',
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
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Column(
                          children: [
                            for (int i = 0; i < left.length; i++)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailMedicine(
                                          medicine: left[i].id,
                                        ),
                                      ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 10),
                                          ],
                                        ),
                                        height: 180,
                                        width: width(context) * 0.39,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: left[i].image != null
                                                  ? Image.network(
                                                      '${left[i].image}',
                                                      width:
                                                          width(context) * 0.35,
                                                      height: 90,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/logo.png',
                                                      width: isTablet(context)
                                                          ? width(context) *
                                                              0.35
                                                          : width(context) *
                                                              0.35,
                                                      height: isTablet(
                                                                  context) ==
                                                              false
                                                          ? height(context) *
                                                              0.07
                                                          : height(context) *
                                                              0.1,
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${left[i].name}',
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
                                              '${left[i].strengths}',
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
                                            Text(
                                              '${formatCurrency(left[i].price)}',
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
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  String formatCurrency(int number) {
    final currencyFormatter = NumberFormat('#,###,000');
    String price = currencyFormatter.format(number);
    return price;
  }
}
