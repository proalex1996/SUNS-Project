import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class TransactionItem extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String datetime;
  TransactionItem({this.datetime, this.image, this.price, this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 21, right: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                image,
                width: 56,
                height: 56,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    price,
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    datetime,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 13,
                        color: AppColor.veryLightPinkTwo),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
