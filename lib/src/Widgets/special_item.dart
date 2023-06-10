import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class SpecialItem extends StatelessWidget {
  final String title;
  final String image;
  final Function onPress;

  SpecialItem({this.title, this.image, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: onPress,
            child: _renderImage(),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: 66,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 15),
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }

  _renderImage() {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) =>
          //  Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(40),
          //     image: DecorationImage(
          //       image: imageProvider,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          CircleAvatar(
        backgroundColor: Color(0xff8f86c1),
        maxRadius: 27,
        child: Image.network(
          image,
          width: 27,
          height: 27,
        ),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColor.paleGreyFour,
        highlightColor: AppColor.whitetwo,
        child: CircleAvatar(
          maxRadius: 27,
          backgroundColor: Color(0xff8f86c1),
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        maxRadius: 27,
        backgroundColor: Color(0xff8f86c1),
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: AssetImage(""),
            ),
          ),
        ),
      ),
    );
  }
}
