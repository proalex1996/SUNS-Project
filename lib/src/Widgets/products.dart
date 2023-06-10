import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductItem extends StatelessWidget {
  final Function press;
  final String image, title, description, gender, birthday;
  final int test, exam, fromAge, toAge, genderN;
  final double price;
  final bool isButton, showPrice;

  ProductItem(
      {Key key,
      this.isButton,
      this.press,
      this.exam,
      this.test,
      this.fromAge,
      this.toAge,
      this.image,
      this.title,
      this.description,
      this.gender,
      this.genderN,
      this.birthday,
      this.price,
      this.showPrice = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    final money = NumberFormat('#,###,000');
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Row(
                  children: <Widget>[
                    image == null
                        ? Image.asset(
                            "assets/images/goikham2.png",
                            width: useMobileLayout ? 99 : 150,
                            height: useMobileLayout ? 87 : 127,
                          )
                        : Image.network(
                            image,
                            width: useMobileLayout ? 99 : 150,
                            height: useMobileLayout ? 87 : 127,
                          ),
                    Container(
                      width: useMobileLayout ? 220 : 330,
                      padding: const EdgeInsets.only(left: 15, right: 7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.only(bottom: 11, left: 10),
                              child: Text(
                                title,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: useMobileLayout ? 18 : 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.darkPurple),
                              ),
                            ),
                          ),
                          // Flexible(
                          //   child: Container(
                          //     padding: const EdgeInsets.only(bottom: 16),
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       description == null ? "" : description,
                          //       style: TextStyle(
                          //         fontFamily: 'Montserrat-M',
                          //         fontSize: useMobileLayout ? 15 : 26,
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(7, 10, 7, 10),
                  padding: const EdgeInsets.only(
                      top: 6.7, left: 11.7, right: 7, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[100]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  width: useMobileLayout ? 16 : 28,
                                  height: useMobileLayout ? 16 : 28,
                                  child: Image.asset(
                                      'assets/images/check-ring.png')),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  _gender(context),
                                  style: TextStyle(
                                      // fontFamily: 'Montserrat-M',
                                      fontStyle: FontStyle.normal,
                                      fontSize: useMobileLayout ? 15 : 26,
                                      color: Color(0xFF9093A3)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  child: Image.asset(
                                'assets/images/check-ring.png',
                                width: useMobileLayout ? 16 : 28,
                                height: useMobileLayout ? 16 : 28,
                              )),
                              Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    _birthday(context),
                                    style: TextStyle(
                                        // fontFamily: 'Montserrat-M',
                                        fontSize: useMobileLayout ? 15 : 26,
                                        color: Color(0xFF9093A3)),
                                  ))
                            ],
                          ),
                        ],
                      )),
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/check-ring.png',
                                width: useMobileLayout ? 16 : 28,
                                height: useMobileLayout ? 16 : 28,
                              ),
                              Container(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Text(
                                    "$test ${AppLocalizations.of(context).test}",
                                    style: TextStyle(
                                        // fontFamily: 'Montserrat-M',
                                        fontSize: useMobileLayout ? 15 : 26,
                                        color: Color(0xFF9093A3)),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/check-ring.png',
                                width: useMobileLayout ? 16 : 28,
                                height: useMobileLayout ? 16 : 28,
                              ),
                              Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "$exam ${AppLocalizations.of(context).examination}",
                                    style: TextStyle(
                                        // fontFamily: 'Montserrat-M',
                                        fontSize: useMobileLayout ? 15 : 26,
                                        color: Color(0xFF9093A3)),
                                  ))
                            ],
                          )
                        ],
                      ))
                    ],
                  )),
              (showPrice)
                  ? Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 11, left: 15, right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations.of(context).price,
                                  style: TextStyle(
                                      fontSize: useMobileLayout ? 14 : 25,
                                      color: Colors.grey)),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                "${money.format(price)} đ",
                                style: TextStyle(
                                    fontSize: useMobileLayout ? 16 : 26,
                                    color: AppColor.darkPurple,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          (isButton)
                              ? InkWell(
                                  onTap: () {
                                    //Button đặt lịch hẹn nhanh
                                    press();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => OrderScreen(
                                    //         gender: gender,
                                    //         fromAge: fromAge,
                                    //         toAge: toAge,
                                    //         companyId: companyId,
                                    //         useBookingTime: useBookingTime,
                                    //         useStaff: useStaff,
                                    //         address: companyAddress,
                                    //         companyType:
                                    //             this.widget.companyType,
                                    //         servicePackageId:
                                    //             this.widget.serviceId.id,
                                    //         isReschedule: false,
                                    //         branchId: _branchId,
                                    //         contact: contact),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 15),
                                    height: useMobileLayout ? 33 : 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColor.purple,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/imgclinic/ic_calendar.png',
                                          width: useMobileLayout ? 15.2 : 30,
                                          height: useMobileLayout ? 15.2 : 30,
                                        ),
                                        SizedBox(
                                          width: 6.8,
                                        ),
                                        Text(
                                          AppLocalizations.of(context).book,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            fontSize: useMobileLayout ? 15 : 26,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  _gender(BuildContext context) {
    if (genderN == 1) {
      return AppLocalizations.of(context).male;
    } else if (genderN == 2) {
      return AppLocalizations.of(context).female;
    } else if (genderN == null) {
      return AppLocalizations.of(context).both;
    }
  }

  _birthday(BuildContext context) {
    if (fromAge != null && toAge != null) {
      return "${AppLocalizations.of(context).from} $fromAge - $toAge ${AppLocalizations.of(context).yearOld}";
    } else if (fromAge != null && toAge == null) {
      return "${AppLocalizations.of(context).from} $fromAge ${AppLocalizations.of(context).yearUp}";
    } else if (fromAge == null && toAge != null) {
      return "${AppLocalizations.of(context).from} $toAge ${AppLocalizations.of(context).down}";
    } else if (fromAge == null && toAge == null) {
      return AppLocalizations.of(context).allAge;
    }
  }
}
