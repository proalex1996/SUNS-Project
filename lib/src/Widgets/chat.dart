import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:suns_med/common/theme/theme_color.dart';

class ChatItem extends StatelessWidget {
  final String img, name, latestContent, textnotifi;
  final DateTime latestTime;
  final Function press;
  ChatItem(
      {this.img,
      this.name,
      this.latestTime,
      this.latestContent,
      this.textnotifi,
      this.press});
  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('vi', timeago.ViMessages());

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: press,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
            top: height * 0.02, left: width * 16 / 375, right: 0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    // CircleAvatar(
                    //   maxRadius: 30,
                    //   backgroundImage: img == null
                    //       ? AssetImage(
                    //           'assets/images/avatar2.png',
                    //         )
                    //       : NetworkImage(img),
                    //   backgroundColor: Colors.transparent,
                    // ),
                    _renderImage(img),
                    SizedBox(
                      width: width * 18.7 / 375,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.02),
                          child: Text(
                            name == null ? "" : name,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: height * 16 / 812,
                                fontWeight: FontWeight.bold,
                                color: AppColor.darkPurple),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          latestContent == null ? "" : latestContent,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: height * 15 / 812,
                              color: AppColor.darkPurple),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          latestTime == null
                              ? ""
                              : timeago.format(
                                  (latestTime).subtract(Duration(minutes: 15)),
                                  locale: 'vi',
                                  allowFromNow: false),
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: height * 15 / 812,
                              color: AppColor.veryLightPinkTwo),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(""),
                        SizedBox(
                          height: height * 24 / 812,
                        ),
                        // Text(
                        //   latestTime == null
                        //       ? ""
                        //       : timeago.format(
                        //           (latestTime).subtract(Duration(minutes: 15)),
                        //           locale: 'vi',
                        //           allowFromNow: false),
                        //   style:TextStyle(
                        //      fontFamily: 'Montserrat-M',
                        //       fontSize: height * 15 / 812,
                        //       color: AppColor.veryLightPinkTwo),
                        // ),
                      ],
                    ),
                    SizedBox(
                      width: width * 60 / 812,
                    ),
                    textnotifi == null
                        ? CircleAvatar(
                            backgroundColor: Colors.transparent,
                            minRadius: 10,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.red,
                            minRadius: 10,
                            child: Text(
                              textnotifi == null ? "" : textnotifi,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.03),
              child: Container(
                height: 1,
                width: width,
                margin: EdgeInsets.fromLTRB(width * 0.02, 0, width * 0.05, 0),
                color: Colors.black12,
              ),
            )
          ],
        ),
      ),
    );
  }

  _renderImage(String image) {
    Widget result;
    var imageDefault = 'assets/images/avatar2.png';
    if (image != null && image.isNotEmpty) {
      result = CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
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
