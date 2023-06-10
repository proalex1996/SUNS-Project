import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/Widgets/rating.dart';
import 'package:suns_med/src/doctor/doctor_model.dart';

class DetailHospitalScreen extends StatefulWidget {
  final Doctor doctor;
  const DetailHospitalScreen({Key key, this.doctor}) : super(key: key);

  @override
  _DetailHospitalScreenState createState() => _DetailHospitalScreenState();
}

class _DetailHospitalScreenState extends State<DetailHospitalScreen> {
  bool selectIndex = true;
  bool selectBool = true;

  List<Marker> allMarker = [];
  @override
  void initState() {
    super.initState();
    allMarker.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        position: LatLng(10.807190, 106.709476)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        centerTitle: true,
        title: Text(
          'Chi tiết bệnh viện',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: selectIndex
                  ? Icon(Icons.favorite_border)
                  : Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                    ),
              onPressed: () {
                setState(() {
                  selectIndex = !selectIndex;
                });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/cover3.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    width: double.infinity,
                    height: 200,
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            maxRadius: 41,
                            child: Image.asset('assets/images/hospital3.png'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              'Bệnh viện Quận Thủ Đức',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 22, top: 23),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                StarRating(
                                  color: Color(0xffffd500),
                                  starCount: 5,
                                  rating: 4,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 8.3,
                                ),
                                Text(
                                  '4.62 ( 45 đánh giá )',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      fontSize: 13,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 18, right: 18, bottom: 19),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        color: Color(0xFFF47A4D),
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/ic_calendar.png',
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              'Đặt lịch khám',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 15,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Container(
                      child: RaisedButton(
                        color: Color(0xffed8200),
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/speak.png',
                              width: 26,
                              height: 21,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              'Chat',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 15,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Container(
                      child: RaisedButton(
                        color: Color(0xff0b841b),
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/video.png',
                              width: 23,
                              height: 16,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              'Video',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 15,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                padding: const EdgeInsets.only(left: 21),
                width: double.infinity,
                height: 40,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Thông tin',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      color: AppColor.deepBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30.4, right: 21, top: 20),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/medical.png',
                      width: 18,
                      height: 18,
                    ),
                    SizedBox(
                      width: 23.3,
                    ),
                    Text(
                      'Chuyên khoa: Đa khoa',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 5.5,
                thickness: 1,
                indent: 21,
                endIndent: 21,
              ),
              Container(
                padding: const EdgeInsets.only(left: 32.7, right: 21, top: 15),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/telephone.png',
                      width: 18,
                      height: 18,
                    ),
                    SizedBox(
                      width: 22.7,
                    ),
                    Text(
                      '0966216565',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 6.5,
                thickness: 1,
                indent: 21,
                endIndent: 21,
              ),
              Container(
                padding: const EdgeInsets.only(left: 32.7, right: 21, top: 13),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/pin.png',
                      width: 13,
                      height: 18,
                    ),
                    SizedBox(
                      width: 25.2,
                    ),
                    Container(
                      width: 285,
                      child: Text(
                        '29 Phú Châu, Khu phố 5, P. Tam Phú, Q. Thủ Đức, TP. Hồ Chí Minh',
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 9.5,
                thickness: 1,
                indent: 21,
                endIndent: 21,
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 30.1, right: 21, top: 13, bottom: 25.1),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/clock.png',
                      width: 18,
                      height: 18,
                    ),
                    SizedBox(
                      width: 23.6,
                    ),
                    Text(
                      'Th2 - CN từ 9h - 20h',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
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
                width: double.infinity,
                height: 40,
                padding: const EdgeInsets.only(
                  left: 21,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hình ảnh',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      color: AppColor.deepBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 19, left: 20, right: 20, bottom: 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            'assets/images/hospital_image1.png',
                            width: 118,
                            height: 118,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        Container(
                          child: Image.asset(
                            'assets/images/hospital_image2.png',
                            width: 100,
                            height: 100,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        Container(
                          child: Image.asset(
                            'assets/images/hospital_image3.png',
                            width: 118,
                            height: 118,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ],
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              'assets/images/hospital_image4.png',
                              width: 118,
                              height: 118,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 12),
                            child: Image.asset(
                              'assets/images/hospital_image5.png',
                              width: 118,
                              height: 118,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                width: double.infinity,
                height: 40,
                padding: const EdgeInsets.only(
                  left: 21,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Giới thiệu',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      color: AppColor.deepBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 350,
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 15,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Phòng khám Nhi khoa Quốc tế The Medcare Hải Phòng là dự án đầu tiên của Công ty Cổ phần Đầu tư Dịch vụ Y tế The Medcare, đồng thời là phòng khám đầu tiên của Hệ thống Phòng khám Nhi khoa Quốc tế The Medcare.',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      'Khởi đầu dự án từ đầu năm 2015, sau 5 tháng xây dựng và triển khai, Phòng khám Nhi khoa Quốc tế The Medcare Hải Phòng đã chính thức hoàn thiện và đi vào hoạt động, bắt đầu từ ngày 11/06/2015',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Xem thêm',
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: AppColor.deepBlue,
                          decoration: TextDecoration.underline),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
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
                padding: const EdgeInsets.only(left: 21),
                width: double.infinity,
                height: 40,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Địa chỉ Google',
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.deepBlue,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(10.807190, 106.709476), zoom: 15.0),
                  markers: Set.from(allMarker),
                ),
              ),
              Container(
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
                padding: const EdgeInsets.only(
                  left: 21,
                ),
                width: double.infinity,
                height: 40,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Đánh giá',
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.deepBlue,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      maxRadius: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/avatar2.png',
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Trương Thị Huyền',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    Text(
                      'Nói cho mọi người biết trải nghiệm của bạn',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 13),
                    ),
                    SizedBox(
                      height: 3.6,
                    ),
                    StarRating(
                      size: 26,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 22, right: 20, top: 42.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Đánh giá khác',
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          color: AppColor.deepBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Xem tất cả',
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          color: AppColor.deepBlue,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 22, top: 28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/avatar1.png',
                      width: 50,
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Lộc Tiến',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: <Widget>[
                              StarRating(
                                rating: 4,
                                color: Color(0xffffd500),
                                size: 15,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '(4.5)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M', fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Khá tốt',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '3 ngày trước',
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: Color(0xffb7b7b7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 11,
                thickness: 1,
                indent: 72.5,
                endIndent: 19.5,
              ),
              Container(
                padding: const EdgeInsets.only(left: 22, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/avatar1.png',
                      width: 50,
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Lộc Tiến',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: <Widget>[
                              StarRating(
                                rating: 4,
                                color: Color(0xffffd500),
                                size: 15,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '(4.5)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M', fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Khá tốt',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '3 ngày trước',
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: Color(0xffb7b7b7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 11,
                thickness: 1,
                indent: 72.5,
                endIndent: 19.5,
              ),
              Container(
                padding: const EdgeInsets.only(left: 22, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/avatar1.png',
                      width: 50,
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Lộc Tiến',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: <Widget>[
                              StarRating(
                                rating: 4,
                                color: Color(0xffffd500),
                                size: 15,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '(4.5)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M', fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Khá tốt',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '3 ngày trước',
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: Color(0xffb7b7b7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 11,
                thickness: 1,
                indent: 72.5,
                endIndent: 19.5,
              ),
              Container(
                padding: const EdgeInsets.only(left: 22, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/avatar1.png',
                      width: 50,
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Lộc Tiến',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: <Widget>[
                              StarRating(
                                rating: 4,
                                color: Color(0xffffd500),
                                size: 15,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '(4.5)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M', fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Khá tốt',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '3 ngày trước',
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: Color(0xffb7b7b7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 11,
                thickness: 1,
                indent: 72.5,
                endIndent: 19.5,
              ),
              Container(
                padding: const EdgeInsets.only(left: 22, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/avatar1.png',
                      width: 50,
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Lộc Tiến',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: <Widget>[
                              StarRating(
                                rating: 4,
                                color: Color(0xffffd500),
                                size: 15,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '(4.5)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M', fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Khá tốt',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '3 ngày trước',
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: Color(0xffb7b7b7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 11,
                thickness: 1,
                indent: 72.5,
                endIndent: 19.5,
              ),
              Container(
                padding: const EdgeInsets.only(left: 22, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/avatar1.png',
                      width: 50,
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Lộc Tiến',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: <Widget>[
                              StarRating(
                                rating: 4,
                                color: Color(0xffffd500),
                                size: 15,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '(4.5)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M', fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Khá tốt',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '3 ngày trước',
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: Color(0xffb7b7b7),
                              fontSize: 13,
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
        ),
      ),
    );
  }
}
