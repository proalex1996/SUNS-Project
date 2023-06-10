import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/detail_hopital_item_screen.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/rating.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HospitalItem extends StatelessWidget {
  final Function press;
  final String image;
  final String name;
  final String specialist;
  final String address;
  final double totalRate;
  final int favorite;
  final bool isDoctor;
  final String provinceId;
  final String companyId;
  final CompanyType companyType;
  HospitalItem(
      {Key key,
      this.provinceId,
      this.companyType,
      this.companyId,
      this.image,
      this.name,
      this.specialist,
      this.address,
      this.favorite,
      this.totalRate,
      this.press,
      this.isDoctor = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5, left: 5, right: 5, top: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  ),
                ]),
            padding:
                const EdgeInsets.only(left: 14, top: 11, right: 15, bottom: 8),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _renderImage(),
                    SizedBox(
                      height: 10.2,
                    ),
                    StarRating(
                      color: AppColor.sunflowerYellow,
                      enable: false,
                      rating: totalRate,
                      starCount: 5,
                      size: 15,
                    ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Divider(
                        height: 18,
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/ic_doctor2.png',
                            width: 11,
                            height: 12,
                          ),
                          SizedBox(
                            width: 7.1,
                          ),
                          Text(
                            _department(),
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 13,
                              color: AppColor.greyishBrown,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/ic_location2.png',
                            width: 11,
                            height: 12,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            // width: 200,
                            child: Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                              // maxLines: 2,
                              style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 13,
                                color: AppColor.greyishBrown,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/ic_heart.png',
                            width: 15,
                            height: 13,
                          ),
                          SizedBox(
                            width: 4.8,
                          ),
                          Text(
                            '$favorite',
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 13,
                              color: AppColor.greyishBrown,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: Container(
              width: 150,
              height: 32,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                color: AppColor.orangeColorDeep,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailHospitalItemScreen(
                        id: this.companyId,
                        type: this.companyType,
                        city: this.provinceId,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/ic_calendar.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(
                      width: 6.8,
                    ),
                    Text(
                      'Đặt lịch khám',
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _department() {
    if (specialist == null) {
      return "Đa khoa";
    }
    return specialist;
  }

  _renderImage() {
    Widget result;
    var imageDefault = this.isDoctor
        ? 'assets/images/doctor2.png'
        : 'assets/images/hospital1.png';

    if (image != null && image.isNotEmpty)
      result = CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          width: 81,
          height: 81,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppColor.paleGreyFour,
          highlightColor: AppColor.whitetwo,
          child: CircleAvatar(
            maxRadius: 40.5,
            backgroundColor: AppColor.paleGreyFour,
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          maxRadius: 40.5,
          backgroundColor: AppColor.paleGreyFour,
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                image: AssetImage(imageDefault),
              ),
            ),
          ),
        ),
      );
    else {
      result = CircleAvatar(
        maxRadius: 40.5,
        backgroundColor: AppColor.paleGreyFour,
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: AssetImage(imageDefault),
            ),
          ),
        ),
      );
    }

    return result;
  }
}
