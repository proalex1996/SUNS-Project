import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:suns_med/src/Widgets/rating.dart';

class FeedbackItem extends StatelessWidget {
  final String image, name, feedback, day;
  final double rating;
  FeedbackItem({this.image, this.name, this.feedback, this.rating, this.day});
  @override
  Widget build(BuildContext context) {
    String date = day;

    timeago.setLocaleMessages('vi', timeago.ViMessages());
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 21,
        right: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _renderImage(),
          Container(
            padding: const EdgeInsets.only(
              left: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    StarRating(
                      size: 15,
                      color: Colors.yellow,
                      starCount: 5,
                      rating: rating,
                    ),
                    SizedBox(width: 10),
                    Text("$rating"),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  feedback,
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  timeago.format(
                      DateTime.parse(date).subtract(Duration(minutes: 15)),
                      locale: 'vi',
                      allowFromNow: true),
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 13,
                      color: Colors.grey),
                ),
                // Divider(
                //   height: 10,
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _renderImage() {
    Widget result;
    var imageDefault = 'assets/images/avatar2.png';
    if (image != null && image.isNotEmpty) {
      result = CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: imageProvider,
            ),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => CircleAvatar(
          maxRadius: 30,
          backgroundColor: Color(0xffebeaef),
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                    image: AssetImage('assets/images/ic_persondefault.png'))),
          ),
        ),
      );
    } else {
      result = Container(
        child: Image.asset(
          imageDefault,
          width: 60,
          height: 60,
        ),
      );
    }
    return result;
  }
}
