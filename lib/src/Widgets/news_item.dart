import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:suns_med/common/theme/theme_color.dart';

class NewItem extends StatelessWidget {
  final String image;
  final String special;
  final String title;
  final String name;
  final String datetime;
  final int favorite;
  final int view;
  final int share;
  final Function onTap;
  NewItem(
      {this.image,
      this.special,
      this.title,
      this.name,
      this.datetime,
      this.favorite,
      this.view,
      this.share,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    String date = datetime;

    timeago.setLocaleMessages('vi', timeago.ViMessages());
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Color(0xffdcdcdc))),
        margin: EdgeInsets.only(top: 18, left: 16, right: 16),
        padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            image == null || image.isEmpty
                ? Image.asset(
                    'assets/images/logo.png',
                    width: 105,
                    height: 105,
                  )
                : Image.network(
                    image,
                    width: 105,
                    height: 105,
                  ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    special,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 13,
                        color: AppColor.deepBlue),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                  SizedBox(
                    height: 29,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        // DateFormat.yMMMd('vi').add_Hms().format(dateTime),
                        timeago.format(
                            DateTime.parse(date)
                                .subtract(Duration(minutes: 15)),
                            locale: 'vi',
                            allowFromNow: false),
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 10,
                            color: AppColor.veryLightPinkTwo),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/ic_heart1.png',
                            width: 16,
                            height: 15,
                          ),
                          SizedBox(
                            width: 6.8,
                          ),
                          Text(
                            _convertIntToFriendlyString(favorite),
                            // _convert1k(),
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 10,
                                color: AppColor.pinkishGrey),
                          ),
                          SizedBox(
                            width: 12.5,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_eye.png',
                                width: 24,
                                height: 15,
                              ),
                              SizedBox(
                                width: 6.8,
                              ),
                              Text(
                                _convertIntToFriendlyString(view),
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 10,
                                    color: AppColor.pinkishGrey),
                              ),
                              // _countView(view),
                            ],
                          ),
                          SizedBox(
                            width: 12.5,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_share1.png',
                                width: 16,
                                height: 15,
                              ),
                              SizedBox(
                                width: 6.8,
                              ),
                              Text(
                                _convertIntToFriendlyString(share),
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 10,
                                    color: AppColor.pinkishGrey),
                              ),
                              // _countShare(share),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _convertIntToFriendlyString(int number) {
    if (number / 1000000 >= 1) {
      return "${(number / 1000000).toStringAsFixed(1)}Tr";
    } else if (number / 1000 >= 1) {
      return "${(number / 1000).toStringAsFixed(1)}N";
    } else {
      return number.toString();
    }
  }
}
