import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/equipment/dto/equipment_model.dart';
import 'package:suns_med/src/Widgets/payment/billorder_screen.dart';
import 'package:suns_med/src/Widgets/slide_dots.dart';
import 'package:suns_med/src/equipment/session_medical_bloc.dart';
import 'package:suns_med/src/equipment/slide_screen.dart';
import 'package:suns_med/src/model/slide.dart';
import 'package:suns_med/src/order/session_confirminfo_bloc.dart';
import 'package:suns_med/src/product/productdetail.dart';
import 'package:html/dom.dart' as dom;

class DetailEquipmentScreen extends StatefulWidget {
  final ProductDetail products;
  final EquipmentModel medicalModel;

  const DetailEquipmentScreen({Key key, this.products, this.medicalModel})
      : super(key: key);

  @override
  _DetailEquipmentScreenState createState() => _DetailEquipmentScreenState();
}

class _DetailEquipmentScreenState extends State<DetailEquipmentScreen> {
  final money = NumberFormat('#,###,000');
  int _index = 0;

  bool onSelect = true;
  int _currentPage = 0;

  final bloc = MedicalBloc();
  final confirmBloc = ConfirmBloc();

  final PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
    bloc.dispatch(EventDetailEquipment(id: widget.medicalModel.id));
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients)
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPagechanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                _buildListSlide(),
                Container(
                  color: Colors.black.withOpacity(0.4),
                  width: double.infinity,
                  height: double.infinity,
                ),
                _buildSlideDots()
              ],
            ),
            _buildContent(),
          ],
        ),
      ),
      floatingActionButton: _buildButtonOrder(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _buildListSlide() {
    return BlocProvider<MedicalEvent, MedicalState, MedicalBloc>(
      bloc: bloc,
      builder: (output) {
        var images = jsonDecode(output?.equipment?.images.toString() ?? 0);
        var checkImages = output?.equipment?.images == null;
        return checkImages
            ? Container()
            : Container(
                height: 280.0,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPagechanged,
                  itemBuilder: (BuildContext context, int index) {
                    return SlideScreen(
                      images: images[index],
                    );
                  },
                ),
              );
      },
    );
  }

  _buildButtonOrder() {
    return BlocProvider<MedicalEvent, MedicalState, MedicalBloc>(
      bloc: bloc,
      builder: (state) {
        return BlocProvider<ConfirmEvent, ConfirmState, ConfirmBloc>(
            bloc: confirmBloc,
            navigator: (confirmState) {
              if (confirmBloc.state.checkStateOrder == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillOrderScreen(
                      medicalModel: state.equipment,
                    ),
                  ),
                );
              }
            },
            builder: (confirmState) {
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        confirmBloc.dispatch(
                            EventPostOrder(equimentId: state.equipment.id));
                      },
                      color: AppColor.deepBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/ic_order.png',
                            width: 12,
                            height: 16,
                          ),
                          SizedBox(
                            width: 7.9,
                          ),
                          Text(
                            "Đặt mua",
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                color: Colors.white,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {},
                        color: AppColor.pumpkin,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/speak.png',
                              width: 26,
                              height: 21,
                            ),
                            SizedBox(
                              width: 10.5,
                            ),
                            Text(
                              "Chat",
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {},
                        color: AppColor.trueGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/video.png',
                              width: 23,
                              height: 16,
                            ),
                            SizedBox(
                              width: 6.7,
                            ),
                            Text(
                              "Video",
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  _buildSlideDots() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 220),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < slide.length; i++)
            if (i == _currentPage)
              SlideDots(true, 15, 15, AppColor.white)
            else
              SlideDots(false, 15, 15, Colors.grey)
        ],
      ),
    );
  }

  _buildContent() {
    return BlocProvider<MedicalEvent, MedicalState, MedicalBloc>(
        bloc: bloc,
        builder: (state) {
          return Container(
            padding: const EdgeInsets.only(top: 40),
            child: Stack(
              children: <Widget>[
                // SingleChildScrollView
                Container(
                  padding: const EdgeInsets.only(top: 220),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 21, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            state.equipment?.name ?? "",
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 12, bottom: 16),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Giá:',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 16),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${money.format(state.equipment?.price ?? 0)}",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " VND",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 18,
                            thickness: 1,
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _index = 0;
                                    });
                                  },
                                  child: Text(
                                    'Mô tả',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        color: _index == 0
                                            ? AppColor.deepBlue
                                            : Colors.black,
                                        fontSize: 16,
                                        decoration: _index == 0
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                        fontWeight: _index == 0
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _index = 1;
                                    });
                                  },
                                  child: Text(
                                    'Thông số kỹ thuật',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 16,
                                        color: _index == 0
                                            ? Colors.black
                                            : AppColor.deepBlue,
                                        decoration: _index == 0
                                            ? TextDecoration.none
                                            : TextDecoration.underline,
                                        fontWeight: _index == 0
                                            ? FontWeight.normal
                                            : FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 26,
                            thickness: 1,
                          ),
                          _index == 0
                              ? Container(
                                  padding: const EdgeInsets.only(bottom: 17),
                                  child: Html(
                                    data: state.equipment?.description ?? "",
                                    defaultTextStyle: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 16,
                                        height: 1.8,
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
                                  // child: Text(
                                  //   widget.medicalModel?.longDescription,
                                  //   style:TextStyle(
                                  //  fontFamily: 'Montserrat-M',fontSize: 16, height: 1.8),
                                  // ),
                                )
                              : Container(
                                  padding: const EdgeInsets.only(bottom: 17),
                                  child: Html(
                                    data: state.equipment?.specifications ?? "",
                                    defaultTextStyle: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 16,
                                        height: 1.8,
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
                                  // child: Text(
                                  //   widget.medicalModel?.longDescription,
                                  //   style:TextStyle(
                                  //    fontFamily: 'Montserrat-M',fontSize: 16, height: 1.8),
                                  // ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 19, left: 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      BackButton(
                        color: AppColor.darkSkyBlue.withOpacity(.5),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 30,
                            child: CircleAvatar(
                              backgroundColor:
                                  AppColor.whitetwo.withOpacity(.9),
                              child: IconButton(
                                  icon: state.hasLike == false
                                      ? Icon(Icons.favorite_border)
                                      : Icon(Icons.favorite),
                                  iconSize: 15,
                                  color: state.hasLike == false
                                      ? Colors.black
                                      : Colors.redAccent,
                                  onPressed: () {
                                    if (state.hasLike == false) {
                                      bloc.dispatch(EventLikeEquipment(
                                          id: state.equipment?.id));
                                    } else {
                                      bloc.dispatch(EventUnlikeEquipment(
                                          id: state.equipment?.id));
                                    }
                                    // setState(() {
                                    //   onSelect = !onSelect;
                                    // });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Image.asset(
                            'assets/images/ic_share.png',
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
