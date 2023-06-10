import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/theme/theme_color.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String createOn;
  final Function press;
  final bool isRead;
  const NotificationItem(
      {Key key,
      this.title,
      this.press,
      this.subTitle,
      this.createOn,
      this.isRead})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String date = createOn;
    DateTime dateTime = DateTime.parse(date);
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 16,
                            color: isRead == false
                                ? AppColor.darkPurple
                                : Colors.grey,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        subTitle,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 16,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Text(
                        DateFormat.yMd('vi').add_Hms().format(dateTime),
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 13,
                          color: AppColor.veryLightPinkTwo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
