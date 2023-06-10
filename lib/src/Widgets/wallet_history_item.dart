import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class WalletHistoryItem extends StatelessWidget {
  final String title;
  final double price;
  final String createOn;
  final Function press;

  const WalletHistoryItem(
      {Key key, this.title, this.press, this.price, this.createOn})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final money = NumberFormat('#,###,000');
    String date = createOn;
    DateTime dateTime = DateTime.parse(date);
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 56,
                  height: 56,
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      child: Text(
                        title,
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text(
                          "${money.format(price)}",
                          style: TextStyle(
                              fontFamily: 'Montserrat-M', fontSize: 16),
                        ),
                        Text(
                          " VND",
                          style: TextStyle(
                              fontFamily: 'Montserrat-M', fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Text(
                      DateFormat.yMd('vi').add_Hms().format(dateTime),
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 13,
                          color: AppColor.veryLightPinkTwo),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              height: 23,
              endIndent: 20,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
