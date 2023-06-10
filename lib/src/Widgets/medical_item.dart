import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/equipment/dto/equipment_model.dart';
import 'package:suns_med/src/Widgets/rating.dart';
import 'package:suns_med/src/equipment/detailequipment_screen.dart';

class MedicalItem extends StatelessWidget {
  final String image, title, price1;
  final double price;
  final int totalRates;

  final Function onPress;
  final EquipmentModel medicalModel;

  MedicalItem(
      {Key key,
      this.image,
      this.title,
      this.onPress,
      this.price1,
      this.price,
      this.totalRates,
      this.medicalModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat('#,###,000');
    return GestureDetector(
      onTap: onPress,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 15, left: 5, right: 5, top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                ),
              ],
            ),
            padding:
                const EdgeInsets.only(top: 11, left: 15, bottom: 12, right: 14),
            child: Row(
              children: <Widget>[
                image == null
                    ? Image.asset(
                        "assets/images/ic_thantietnieu.png",
                        color: AppColor.deepBlue,
                        width: 80,
                        // fit: BoxFit.cover,
                        height: 80,
                      )
                    : Image.network(
                        image,
                        width: 80,
                        fit: BoxFit.cover,
                        height: 80,
                      ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 15),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                "${money.format(price)}",
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    color: Colors.red,
                                    fontSize: 13),
                              ),
                              Text(
                                " VND",
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    color: Colors.red,
                                    fontSize: 13),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 7.2,
                      ),
                      StarRating(
                        color: AppColor.sunflowerYellow,
                        rating: totalRates.ceilToDouble(),
                        starCount: 5,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: -5,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              color: AppColor.deepBlue,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailEquipmentScreen(
                              medicalModel: this.medicalModel,
                            )));
              },
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/ic_order.png',
                    width: 12,
                    height: 16,
                  ),
                  SizedBox(
                    width: 11.9,
                  ),
                  Text(
                    'Đặt mua',
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
