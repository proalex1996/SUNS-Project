import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/feedback.dart';
import 'package:suns_med/src/Widgets/products.dart';
import 'package:suns_med/src/Widgets/rating.dart';
import 'package:suns_med/src/product/session_service_package_bloc.dart';
import 'package:suns_med/src/rating/userrating_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class BodyDetailsScreen extends StatefulWidget {
  final String id;
  final String city;
  final CompanyType type;
  BodyDetailsScreen(
      {Key key, @required this.id, this.city, @required this.type})
      : super(key: key);

  @override
  _BodyDetailsScreenState createState() => _BodyDetailsScreenState();
}

class _BodyDetailsScreenState extends State<BodyDetailsScreen> {
  bool selectBool = true;
  bool selectShow = true;

  final bloc = DetailItemBloc();
  final userBloc = SessionBloc();
  final serviceBloc = ServicePackageBloc();
  GoogleMapController googleMapController;

  List<Marker> allMarker = [];

  @override
  void initState() {
    if (this.widget.type == CompanyType.Doctor) {
      bloc.dispatch(LoadDetailDoctorEvent(id: widget.id));
    } else if (this.widget.type == CompanyType.Clinic) {
      bloc.dispatch(LoadDetailClinicEvent(id: widget.id));
    } else if (this.widget.type == CompanyType.Hospital) {
      bloc.dispatch(LoadDetailHospitalEvent(id: widget.id));
    }

    if (Platform.isAndroid) {
      allMarker.add(
        Marker(
          markerId: MarkerId('myMarker'),
          draggable: false,
          position:
              _convertStringToLatLng(bloc.state?.detailItem?.latLong ?? "0"),

          // infoWindow: InfoWindow(title: 'Min Milk Tea - Cafe', )
        ),
      );
    } else if (Platform.isIOS) {
      allMarker.add(
        Marker(
          markerId: MarkerId('myMarker'),
          draggable: false,
          position:
              _convertStringToLatLng(bloc.state?.detailItem?.latLong ?? "0"),
          // infoWindow: InfoWindow(title: 'Min Milk Tea - Cafe', )
          onTap: () {
            launchMap(latitude: "10.8071137", longitude: "106.7094436");
          },
        ),
      );
    }

    super.initState();
  }

  void mapCreated(controller) {
    setState(() {
      googleMapController = controller;
    });
  }

  launchMap(
      {String latitude = "10.8071137",
      String longitude = "106.7094436"}) async {
    var googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not launch $googleUrl';
    }
  }

  LatLng _convertStringToLatLng(String data) {
    var latLong = data?.split(";");

    if (latLong?.length == 2) {
      var lat = double.parse(latLong[0]);
      var long = double.parse(latLong[1]);

      return LatLng(lat, long);
    }

    return LatLng(10.8071137, 106.7094436);
  }

  bool checkLengthServicePackage = true;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return BlocProvider<DetailItemEvent, DetailItemState, DetailItemBloc>(
      bloc: bloc,
      builder: (state) {
        var detailDHC = state.detailDHC;
        var checkState = detailDHC == null;
        // LatLng _position = LatLng(detailDoctor?.latitude?.toDouble(),
        //     detailDoctor?.longitude?.toDouble());
        return checkState
            ? Container()
            : Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 198,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/cover1.png'),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        width: double.infinity,
                        height: 198,
                        color: Colors.black.withOpacity(0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _renderImage(detailDHC?.logoImage),
                            Container(
                              child: Text(
                                detailDHC?.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 90, right: 90, bottom: 23),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  StarRating(
                                    color: Color(0xffffd500),
                                    enable: false,
                                    rating: detailDHC?.rating,
                                    starCount: 5,
                                    size: 15,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${detailDHC?.rating} ',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            fontSize: 13,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        '(${detailDHC.totalRating} đánh giá)',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            fontSize: 13,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.veryLightPinkFour,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black12,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.only(left: 21),
                        child: Text(
                          'Thông tin',
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              color: AppColor.deepBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 31, right: 31),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 19),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  width: 17.3,
                                  height: 17.3,
                                  child: Image.asset(
                                      'assets/images/telephone.png')),
                              Container(
                                padding: const EdgeInsets.only(left: 22.7),
                                child: Text(
                                  detailDHC?.phone,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 6.5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 19),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  width: 17.3,
                                  height: 13.6,
                                  child:
                                      Image.asset('assets/images/message.png')),
                              Container(
                                padding: const EdgeInsets.only(left: 22.7),
                                child: Text(
                                  detailDHC?.email,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 6.5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 19),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  width: 12.1,
                                  height: 17.1,
                                  child: Image.asset('assets/images/pin.png')),
                              Container(
                                padding: const EdgeInsets.only(left: 22.7),
                                child: Text(
                                  detailDHC?.address,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 6.5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 19),
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/home1.png',
                                width: 17.3,
                                height: 16.1,
                              ),
                              SizedBox(
                                width: 22,
                              ),
                              Expanded(
                                child: Text(
                                  detailDHC?.name,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 6.5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 19),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  width: 17.3,
                                  height: 17,
                                  child:
                                      Image.asset('assets/images/medical.png')),
                              Container(
                                padding: const EdgeInsets.only(left: 22.7),
                                child: Text(
                                  detailDHC?.specialized,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 6.5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 19),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  width: 17.3,
                                  height: 17.3,
                                  child:
                                      Image.asset('assets/images/clock.png')),
                              Container(
                                padding: const EdgeInsets.only(left: 22.7),
                                child: Text(
                                  detailDHC?.workingTime,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 6.5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 19),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  child: Container(
                                      width: 17.3,
                                      height: 14.8,
                                      child: Image.asset(
                                          'assets/images/student.png'))),
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          const EdgeInsets.only(left: 22.7),
                                      width: 274,
                                      child: Text(
                                        detailDHC.introInfo,
                                        maxLines: selectBool ? 3 : 50,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            fontSize: 16),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectBool = !selectBool;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 14, left: 20, bottom: 17),
                                          child: selectBool
                                              ? Text(
                                                  "Xem thêm",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-M',
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontSize: 16,
                                                      color: AppColor.deepBlue),
                                                )
                                              : Text(
                                                  "Rút gọn",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-M',
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontSize: 16,
                                                      color: AppColor.deepBlue),
                                                ),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.veryLightPinkFour,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black12,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.only(left: 21),
                        child: Text(
                          'Dịch vụ gói khám',
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              color: AppColor.deepBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    children: List.generate(
                      state.listServiceOfCompany.data.length,
                      (index) {
                        var service = state.listServiceOfCompany.data[index];
                        return ProductItem(
                          title: service?.name,
                          image: service?.image,
                          description: service.description == null
                              ? "Không có nội dung"
                              : service?.description,
                          genderN: service?.gender,
                          fromAge: service?.fromAge,
                          toAge: service?.toAge,
                          exam: service?.exam,
                          test: service?.test,
                          price: service?.price?.toDouble(),
                          press: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => DetailProductScreen(
                            //       detailDHCModel: detailDHC,
                            //       companyType: this.widget.type,
                            //       serviceId: service,
                            //       companyId: widget.id,
                            //       address: state.detailDHC.address,
                            //     ),
                            //   ),
                            // );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                      alignment: state.listServiceOfCompany.data.isEmpty
                          ? Alignment.center
                          : Alignment.centerRight,
                      margin: EdgeInsets.only(right: 22, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            checkLengthServicePackage =
                                !checkLengthServicePackage;
                            !checkLengthServicePackage
                                ? bloc.dispatch(EventGetAllServicePackage(
                                    pageSize:
                                        state.listServiceOfCompany.totalCount))
                                : bloc.dispatch(
                                    EventGetAllServicePackage(pageSize: 3));
                          });
                        },
                        child: Text(
                            state.listServiceOfCompany.totalCount <= 3
                                ? ""
                                : checkLengthServicePackage
                                    ? 'Xem tất cả'
                                    : "Rút gọn",
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                color: AppColor.deepBlue,
                                decoration: TextDecoration.underline)),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.veryLightPinkFour,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black26,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.only(left: 21),
                        child: Text(
                          'Địa chỉ Google',
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              color: AppColor.deepBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 375,
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          detailDHC?.latitude?.toDouble(),
                          detailDHC?.longitude?.toDouble(),
                        ),
                        zoom: 16.0,
                      ),
                      markers: Set.from(allMarker),
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      mapToolbarEnabled: true,
                      scrollGesturesEnabled: true,
                      compassEnabled: true,
                      mapType: MapType.normal,
                    ),
                  ),
                  Container(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.veryLightPinkFour,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black12,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.only(left: 21),
                        child: Text(
                          'Đánh giá',
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              color: AppColor.deepBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  BlocProvider<EventSession, StateSession, SessionBloc>(
                      bloc: userBloc,
                      builder: (userState) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  maxRadius: 40,
                                  backgroundColor: AppColor.greyColor,
                                  backgroundImage: userState.user.avatar == null
                                      ? AssetImage("assets/images/avatar2.png")
                                      : NetworkImage(userState.user.avatar),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Text(
                                    userState.user.fullName.isEmpty
                                        ? "Hãy cập nhật thông tin của bạn ${userState.user.phoneNumber}"
                                        : userState.user?.fullName,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10, left: 25, right: 20),
                                  child: Text(
                                    state.allowedRating == true
                                        ? 'Nói cho mọi người biết trải nghiệm của bạn'
                                        : "Bạn cần hoàn thành giao dịch với bác sĩ, phòng khám, bệnh viện này để được đánh giá.",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 13),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16.6),
                                  child: StarRating(
                                    onPress: () {
                                      if (state.allowedRating == true) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserRatingScreen(
                                              companyType: this.widget.type,
                                              companyId: state.detailDHC.id,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    color: Colors.amber,
                                    starCount: 5,
                                    rating: 0,
                                  ),
                                ),
                                Divider(
                                  height: 23.9,
                                  color: Colors.grey,
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.only(top: 10, left: 21, bottom: 16),
                    child: Text(
                      state.listRatingOfCompany == null ||
                              state.listRatingOfCompany.isEmpty
                          ? ""
                          : 'Đánh giá khác',
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: AppColor.deepBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    children: List.generate(
                      state?.listRatingOfCompany?.length ?? 0,
                      (index) {
                        var rateInfo = state?.listRatingOfCompany[index];
                        var rating = double.parse(rateInfo?.rating.toString());
                        var userRatingId = rateInfo.userId ?? 0;
                        var userValue = state?.listUserRating?.any((element) =>
                                    int.parse(element.id) == userRatingId) ==
                                true
                            ? state?.listUserRating?.firstWhere((element) =>
                                int.parse(element.id) == userRatingId)
                            : null;
                        return Container(
                          padding: const EdgeInsets.only(top: 12, bottom: 20),
                          child: Column(
                            children: <Widget>[
                              FeedbackItem(
                                image: userValue?.avatar ?? "",
                                name: userValue?.fullName ?? "",
                                rating: rating,
                                feedback: rateInfo?.comment == null
                                    ? "Khá tốt"
                                    : rateInfo?.comment,
                                day: rateInfo?.createdTime
                                    ?.toLocal()
                                    ?.toIso8601String(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
      },
    );
  }

  _renderImage(String image) {
    return image == null
        ? CircleAvatar(
            maxRadius: 40.5,
            backgroundColor: Color(0xffebeaef),
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                      image: AssetImage('assets/images/doctor2.png'))),
            ),
          )
        : CachedNetworkImage(
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
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => CircleAvatar(
              maxRadius: 40.5,
              backgroundColor: Color(0xffebeaef),
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                        image: AssetImage('assets/images/doctor2.png'))),
              ),
            ),
          );
  }
  // return CircleAvatar(
  //   backgroundColor: Colors.grey,
  //   backgroundImage: detailDoctor.avatar.isNotEmpty
  //       ? NetworkImage(detailDoctor?.avatar)
  //       : null,
  // );

}
