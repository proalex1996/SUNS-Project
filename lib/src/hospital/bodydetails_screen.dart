import 'package:flutter/material.dart';
import 'package:suns_med/src/Widgets/rating.dart';
import 'package:suns_med/src/doctor/doctor_model.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class BodyDetailsScreen extends StatefulWidget {
  final Doctor doctor;

  const BodyDetailsScreen({Key key, this.doctor}) : super(key: key);

  @override
  _BodyDetailsScreenState createState() => _BodyDetailsScreenState();
}

class _BodyDetailsScreenState extends State<BodyDetailsScreen> {
  // ignore: unused_field
  int _index = 0;
  final List<double> heights = [
    60,
    325,
  ];
  final List<String> texts = ['Xem Thêm'];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 198,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/cover3.png'),
                      fit: BoxFit.cover)),
            ),
            Container(
              width: double.infinity,
              height: 198,
              color: Colors.black.withOpacity(0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    child: CircleAvatar(
                      backgroundColor: Color(0xffebeaef),
                      maxRadius: 41,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                                image: AssetImage(widget.doctor.image))),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 59, right: 59),
                    child: Text(
                      widget.doctor.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 94, right: 94, bottom: 23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StarRating(
                          color: Color(0xffffd500),
                          enable: false,
                          rating: 4,
                          starCount: 5,
                          size: 15,
                        ),
                        Text(
                          '4.62 ( 45 đánh giá )',
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 13,
                              color: Colors.white),
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
          padding:
              const EdgeInsets.only(left: 21, right: 21, top: 14, bottom: 19),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(right: 10, left: 15),
                height: 33,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Color(0xFFF47A4D),
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
                      width: 6.8,
                    ),
                    Text(
                      'Đặt lịch khám',
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10, left: 21),
                height: 33,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Color(0xffed8200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/speak.png'),
                    SizedBox(
                      width: 6.8,
                    ),
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 21, left: 10),
                height: 33,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Color(0xff0b841b),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/video.png'),
                    SizedBox(
                      width: 6.8,
                    ),
                    Text(
                      'Video',
                      style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Card(
            elevation: 3,
            color: Color(0xffebeaef),
            child: Container(
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
        ),
        Container(
          padding: const EdgeInsets.only(left: 31, right: 31),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 19),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/telephone.png'),
                    Container(
                      padding: const EdgeInsets.only(left: 22.7),
                      child: Text(
                        widget.doctor.phone,
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
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
                    Image.asset('assets/images/message.png'),
                    Container(
                      padding: const EdgeInsets.only(left: 22.7),
                      child: Text(
                        widget.doctor.email,
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
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
                    Image.asset('assets/images/pin.png'),
                    Container(
                      padding: const EdgeInsets.only(left: 22.7),
                      child: Text(
                        widget.doctor.location,
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
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
                    Image.asset('assets/images/home1.png'),
                    Container(
                      padding: const EdgeInsets.only(left: 22.7),
                      child: Text(
                        widget.doctor.address,
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
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
                    Image.asset('assets/images/medical.png'),
                    Container(
                      padding: const EdgeInsets.only(left: 22.7),
                      child: Text(
                        widget.doctor.specialist,
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
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
                    Image.asset('assets/images/clock.png'),
                    Container(
                      padding: const EdgeInsets.only(left: 22.7),
                      child: Text(
                        widget.doctor.time,
                        style:
                            TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
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
                        child: Image.asset('assets/images/student.png')),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 22.7),
                            height: 60,
                            width: 274,
                            child: Text(
                              widget.doctor.education,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M', fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _index = 0;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 14, left: 20, bottom: 17),
                              child: Text(
                                'Xem thêm',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 16,
                                    color: AppColor.deepBlue),
                              ),
                            ),
                          )
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
          child: Card(
            elevation: 3,
            color: Color(0xffebeaef),
            child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.only(left: 21),
                child: Text(
                  'Dịch vụ phòng khám',
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      color: AppColor.deepBlue,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 7, right: 7, top: 10),
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/images/goikham.png'),
                      Container(
                        width: 220,
                        padding: const EdgeInsets.only(left: 10, right: 7),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(bottom: 11),
                              child: Text(
                                'Gói kiểm tra sức khoẻ cơ bản',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 16),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  'Kiểm tra sức khoẻ cơ bản qua các xét nghiệm thường quy, điện tim và X-quang phổi…'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(7, 10, 7, 10),
                    padding: const EdgeInsets.only(
                        top: 6.7, left: 11.7, right: 7, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(.3)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset('assets/images/gender.png'),
                                Container(
                                    padding: const EdgeInsets.only(left: 13),
                                    child: Text('Nam và nữ'))
                              ],
                            ),
                            SizedBox(
                              height: 9,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset('assets/images/birthday.png'),
                                Container(
                                    padding: const EdgeInsets.only(left: 13),
                                    child: Text('Mọi lứa tuổi'))
                              ],
                            )
                          ],
                        )),
                        Container(
                            child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset('assets/images/lab.png'),
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 13, right: 32),
                                    child: Text('15 thí nghiệm'))
                              ],
                            ),
                            SizedBox(
                              height: 9,
                            ),
                            Row(
                              children: <Widget>[
                                Image.asset('assets/images/hospital.png'),
                                Container(
                                    padding: const EdgeInsets.only(left: 13),
                                    child: Text('5 hạng mục khám'))
                              ],
                            )
                          ],
                        ))
                      ],
                    )),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 11, left: 7, right: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text('Giá dịch vụ',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 15,
                                  color: AppColor.deepBlue)),
                          SizedBox(
                            height: 7,
                          ),
                          Text('1.500.000đ',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10, left: 15),
                        height: 33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color: AppColor.deepBlue,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/ic_calendar.png',
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(
                              width: 6.8,
                            ),
                            Text(
                              'Đặt lịch hẹn',
                              style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
