import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/Widgets/rating.dart';

class DetailsClinicScreen extends StatefulWidget {
  @override
  _DetailsClinicScreenState createState() => _DetailsClinicScreenState();
}

class _DetailsClinicScreenState extends State<DetailsClinicScreen> {
  bool selectBool = true;

  List<Marker> allMarker = [];
  @override
  void initState() {
    super.initState();
    allMarker.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        position: LatLng(10.807190, 106.709476)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: Text('Chi tiết phòng khám'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
            highlightColor: Colors.red,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 198,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/cover4.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 198,
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            maxRadius: 40,
                            child: Container(
                              margin: EdgeInsets.all(12),
                              child: Image.asset('assets/images/hospital1.png'),
                            ),
                          ),
                          Container(
                            width: 250,
                            child: Text(
                              'Phòng khám Nhi khoa Quốc tế The MedCare',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              StarRating(
                                rating: 4,
                                color: Color(0xffffd500),
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '4.62 ( 45 đánh giá )',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 19, bottom: 19, left: 21, right: 21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        color: Color(0xFFF47A4D),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/ic_calendar.png',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Đặt lịch khám',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {},
                        color: Color(0xFFF47A4D),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/speak.png',
                              width: 26,
                              height: 21,
                            ),
                            SizedBox(
                              width: 5,
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {},
                        color: Color(0xFFF47A4D),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/video.png',
                              width: 23,
                              height: 16,
                            ),
                            SizedBox(
                              width: 5,
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
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
                height: 40,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 21),
                child: Text(
                  'Thông tin',
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    color: AppColor.deepBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 21, right: 21, top: 18.6, bottom: 45),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 10),
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
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 6.5,
                      thickness: 1.5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 13, left: 10),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/message.png',
                            width: 18,
                            height: 14,
                          ),
                          SizedBox(
                            width: 21.7,
                          ),
                          Text(
                            'Nhakhoatrendsmile@gmail.com',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 6.5,
                      thickness: 1.5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 13, left: 11.7),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/pin.png',
                            width: 13,
                            height: 18,
                          ),
                          SizedBox(
                            width: 26.2,
                          ),
                          Text(
                            '255 Phố Huế, Hai Bà Trưng, Hà Nội',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 6.5,
                      thickness: 1.5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 13, left: 11.1),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/home1.png',
                            width: 18,
                            height: 17,
                          ),
                          SizedBox(
                            width: 22.6,
                          ),
                          Container(
                            width: 283,
                            child: Text(
                              'Hệ thống Nha khoa thẩm mỹ quốc tế Trendsmile',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M', fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 6.5,
                      thickness: 1.5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 13, left: 9.4),
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
                            'Chuyên khoa: Răng - Hàm - Mặt',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 6.5,
                      thickness: 1.5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 13, left: 9.1),
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
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 6.5,
                      thickness: 1.5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 13, left: 9.1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/student.png',
                            width: 18,
                            height: 15,
                          ),
                          SizedBox(
                            width: 23.6,
                          ),
                          Container(
                            width: 283,
                            child: Text(
                              'Từ năm 2006 – 2012: Tốt nghiệp Viện đào tạo răng hàm mặt Đại học Y Hà Nội Từ năm 2013 – nay: Tham gia khóa đào tạo thực hành “Thiết kế nụ cười trong Nha khoa” cùng Dr. David Montalvo Arias (hiện đang làm việc tại Apa Aesthetics UAE) bậc thầy trong Thiết kế nụ cười Tham gia khóa đào tạo chuyên sâu “ Thẩm mỹ nội khoa không dao kéo” cùng Dr. David Dana (Education Director tại Progressive Orthodontic Seminars) Tham gia khóa đào tạo Phục hình Inlay, Công nghệ sứ sinh học trong phục hồi răng thẩm mỹ do Mani Schutz Dental tổ chức.',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M', fontSize: 16),
                            ),
                          )
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
                height: 40,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 21),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dịch vụ phòng khám',
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    color: AppColor.deepBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xfff8f8f8)),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 7, top: 12, right: 10),
                              child: Image.asset('assets/images/ic_cover2.png'),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 10,
                                right: 7,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Gói kiểm tra sức khở cơ bản',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 11),
                                    width: 212,
                                    child: Text(
                                      'Kiểm tra sức khoẻ cơ bản qua các xét nghiệm thường quy, điện tim và X-quang phổi…',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 15,
                                        color: Color(0xff515151),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding:
                              const EdgeInsets.only(left: 7, right: 7, top: 10),
                          height: 65,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffeeeeee),
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 6.7, left: 11.7, right: 34),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        // padding:
                                        //     const EdgeInsets.only(right: 103),
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/images/gender.png',
                                              width: 15,
                                              height: 15,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 13.2),
                                              child: Text(
                                                'Nam và nữ',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat-M',
                                                  fontSize: 13,
                                                  color: Color(0xff515151),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // padding:
                                        //     const EdgeInsets.only(right: 34),
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/images/lab.png',
                                              width: 16,
                                              height: 13,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                '15 thí nghiệm',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat-M',
                                                  fontSize: 13,
                                                  color: Color(0xff515151),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 8.6, left: 11.7, right: 7),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/images/birthday.png',
                                            width: 15,
                                            height: 14,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 12.7),
                                            child: Text(
                                              'Mọi lứa tuổi',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat-M',
                                                fontSize: 13,
                                                color: Color(0xff515151),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/images/hospital.png',
                                              width: 15,
                                              height: 13,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 12),
                                              child: Text(
                                                '5 hạng mục khám',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat-M',
                                                  fontSize: 13,
                                                  color: Color(0xff515151),
                                                ),
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
                        Container(
                          padding: const EdgeInsets.only(
                              left: 7, top: 10, bottom: 9, right: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Giá dịch vụ',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      fontSize: 15,
                                      color: AppColor.deepBlue,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    '1.500.000đ',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      fontSize: 15,
                                      color: Color(0xffff0031),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                // margin: EdgeInsets.only(left: 120, right: 7),
                                width: 150,
                                height: 33,
                                child: RaisedButton(
                                  onPressed: () {},
                                  color: AppColor
                                      .orangeColorDeep, //AppColor.deepBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/ic_calendar.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(
                                        width: 12.4,
                                      ),
                                      Text(
                                        'Đặt lịch hẹn',
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
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 22),
                child: Text(
                  'Xem tất cả',
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                    color: AppColor.deepBlue,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                color: AppColor.veryLightPinkFour,
                height: 40,
                alignment: Alignment.centerLeft,
                width: double.infinity,
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
                padding: const EdgeInsets.only(left: 21),
                height: 40,
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  'Đánh giá',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      color: AppColor.deepBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      maxRadius: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/avatar.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Trương Thị Huyền',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Nói cho mọi người biết trải nghiệm của bạn',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 13),
                    ),
                    SizedBox(
                      height: 16.6,
                    ),
                    StarRating(
                      size: 25,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 21.5, right: 20.5),
                child: Divider(
                  height: 25,
                  thickness: 1,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Đánh giá khác',
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.deepBlue,
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.only(left: 178),
                      child: Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: AppColor.deepBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 25, left: 21),
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
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 12.2),
                            child: Row(
                              children: <Widget>[
                                StarRating(
                                  rating: 4,
                                  size: 15,
                                  color: Color(0xffffd500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '(4.5)',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 13),
                                )
                              ],
                            ),
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
                                fontSize: 13,
                                color: Color(0xffb7b7b7)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 13,
                thickness: 1,
                indent: 71.5,
                endIndent: 20.5,
              ),
              Container(
                padding: const EdgeInsets.only(top: 25, left: 21),
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
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 12.2),
                            child: Row(
                              children: <Widget>[
                                StarRating(
                                  rating: 4,
                                  size: 15,
                                  color: Color(0xffffd500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '(4.5)',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 13),
                                )
                              ],
                            ),
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
                                fontSize: 13,
                                color: Color(0xffb7b7b7)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 13,
                thickness: 1,
                indent: 71.5,
                endIndent: 20.5,
              ),
              Container(
                padding: const EdgeInsets.only(top: 25, left: 21),
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
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 12.2),
                            child: Row(
                              children: <Widget>[
                                StarRating(
                                  rating: 4,
                                  size: 15,
                                  color: Color(0xffffd500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '(4.5)',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 13),
                                )
                              ],
                            ),
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
                                fontSize: 13,
                                color: Color(0xffb7b7b7)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 13,
                thickness: 1,
                indent: 71.5,
                endIndent: 20.5,
              ),
              Container(
                padding: const EdgeInsets.only(top: 25, left: 21),
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
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 12.2),
                            child: Row(
                              children: <Widget>[
                                StarRating(
                                  rating: 4,
                                  size: 15,
                                  color: Color(0xffffd500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '(4.5)',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 13),
                                )
                              ],
                            ),
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
                                fontSize: 13,
                                color: Color(0xffb7b7b7)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 13,
                thickness: 1,
                indent: 71.5,
                endIndent: 20.5,
              ),
              Container(
                padding: const EdgeInsets.only(top: 25, left: 21),
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
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 12.2),
                            child: Row(
                              children: <Widget>[
                                StarRating(
                                  rating: 4,
                                  size: 15,
                                  color: Color(0xffffd500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '(4.5)',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 13),
                                )
                              ],
                            ),
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
                                fontSize: 13,
                                color: Color(0xffb7b7b7)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 13,
                thickness: 1,
                indent: 71.5,
                endIndent: 20.5,
              ),
              Container(
                padding: const EdgeInsets.only(top: 25, left: 21),
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
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 12.2),
                            child: Row(
                              children: <Widget>[
                                StarRating(
                                  rating: 4,
                                  size: 15,
                                  color: Color(0xffffd500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '(4.5)',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M', fontSize: 13),
                                )
                              ],
                            ),
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
                                fontSize: 13,
                                color: Color(0xffb7b7b7)),
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
