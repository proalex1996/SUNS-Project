import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/src/Widgets/appointment_history_item.dart';
import 'package:suns_med/src/contacts/healthchart_screen.dart';
import 'package:suns_med/src/contacts/qrcode_screen.dart';
import 'package:suns_med/src/contacts/session_contacts_bloc.dart';

import 'appointmenthistory/detailhistory_screen.dart';
import 'appointmenthistory/session_appointmenthistory_bloc.dart';

class DetailContactScreen extends StatefulWidget {
  final ContactModel contactModel;
  final String relationShipValue;
  final String genderValue;
  const DetailContactScreen({
    Key key,
    this.contactModel,
    this.genderValue,
    this.relationShipValue,
  }) : super(key: key);

  @override
  _DetailContactScreenState createState() => _DetailContactScreenState();
}

class _DetailContactScreenState extends State<DetailContactScreen> {
  final bloc = ContactBloc();
  final historyBloc = AppointmentHistoryBloc();
  bool _isShowHistory = false;
  final money = NumberFormat('#,###,000');
  @override
  void initState() {
    bloc.dispatch(LoadContactEvent());
    bloc.dispatch(LoadRelationship());
    bloc.dispatch(LoadGenderEvent());
    bloc.dispatch(LoadTotalCostEvent(id: widget.contactModel?.id));
    historyBloc.dispatch(LoadRelationshipHistoryEvent());
    historyBloc.dispatch(LoadMedicalExamination(id: widget?.contactModel?.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.veryLightPinkFour,
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: Text(
          'Chi tiết người thân',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTitle('Hồ sơ người thân'),
            BlocProvider<ContactEvent, ContactState, ContactBloc>(
              bloc: bloc,
              builder: (output) {
                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                      left: 21, top: 17, right: 20, bottom: 13.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/price1.png',
                        width: 11,
                        height: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'TỔNG CHI PHÍ KHÁM BỆNH',
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.veryLightPinkTwo),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Text(
                          output?.totalCost == null
                              ? ""
                              : "${money.format(output?.totalCost)}",
                          style: TextStyle(
                              fontFamily: 'Montserrat-M', fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 5,
            ),
            _buildContent(),
            _buildTitle('QR Code'),
            _buildSeenDetails(
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodeScreen(
                      qrcodeModel: widget.contactModel,
                    ),
                  ),
                );
              },
            ),
            // _buildTitle('Lịch sử khám bệnh'),
            // _buildSeenDetails(
            //   () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => AppointmentHistoryScreen(
            //           relationShipValue: widget.relationShipValue,
            //           contactModel: widget.contactModel,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            _buildTitle('Sức khỏe'),
            _buildSeenDetails(
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthChartScreen(
                      idContact: widget.contactModel.id,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            _buildAppointment(),
          ],
        ),
      ),
    );
  }

  _buildAppointment() {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
        AppointmentHistoryBloc>(
      bloc: historyBloc,
      builder: (output) {
        var isNotNull = output.medicalExamination == null ||
            output.medicalExamination?.length == 0;
        var checkLenght = isNotNull
            ? 0
            : output.medicalExamination.length >= 5
                ? 5
                : output.medicalExamination.length;
        return isNotNull
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  "Chưa có lịch sử khám bệnh",
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 18,
                      color: Colors.black),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lịch sử khám",
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: AppColor.deepBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        checkLenght < 5
                            ? SizedBox()
                            : MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    _isShowHistory = !_isShowHistory;
                                  });
                                },
                                child: Text(
                                  _isShowHistory ? "Xem tất cả" : "Rút gọn",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      color: AppColor.deepBlue),
                                ),
                              )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Wrap(
                    children: List.generate(
                        _isShowHistory
                            ? checkLenght
                            : output.medicalExamination?.length ?? 0, (index) {
                      var medicalExamination = output.medicalExamination[index];
                      var time = medicalExamination?.createdTime == null
                          ? ""
                          : DateFormat.yMd("vi_VN")
                              .add_Hm()
                              .format(medicalExamination?.createdTime);
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: AppointmentHistoryItem(
                          fullName: medicalExamination?.name,
                          id: medicalExamination?.appointmentCode,
                          appointDate: time,
                          clinicName: medicalExamination?.staffName,
                          // relationShip: item.value,
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailHistoryScreen(
                                  id: medicalExamination?.id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              );
      },
    );
  }

  _buildContent() {
    return BlocProvider<ContactEvent, ContactState, ContactBloc>(
      bloc: bloc,
      builder: (output) {
        return Container(
          color: Colors.white,
          padding:
              const EdgeInsets.only(left: 21, top: 13, bottom: 20, right: 51),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thông tin cá nhân',
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    color: AppColor.deepBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/user1.png',
                    width: 14,
                    height: 16,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.contactModel.fullName,
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/relationship.png',
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.relationShipValue ?? "Bạn bè",
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/telephone1.png',
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.contactModel.phoneNumber ?? "Không có",
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/calendar.png',
                            width: 14,
                            height: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            DateFormat.yMd('vi')
                                .format(widget?.contactModel?.birthDay),
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 21.5,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/gender1.png',
                            width: 15,
                            height: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.genderValue,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M', fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/cmnd.png',
                    width: 16,
                    height: 12,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.contactModel.personalNumber ?? "Không có",
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/email.png',
                    width: 14,
                    height: 11,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  _email(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/location.png',
                    width: 14,
                    height: 20,
                  ),
                  SizedBox(
                    width: 10.5,
                  ),
                  Flexible(
                    child: Text(
                      widget.contactModel.address == null ||
                              widget.contactModel.address.isEmpty
                          ? "Chưa cập nhật địa chỉ"
                          : widget.contactModel.address,
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                  ),
                ],
              ) // Container(
              //   padding: const EdgeInsets.only(bottom: 77.6, left: 20),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Image.asset(
              //             'assets/images/calendar.png',
              //             width: 14,
              //             height: 16,
              //           ),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Text(
              //             DateFormat.yMd('vi').format(dateTime),
              //             style:TextStyle(
              //      fontFamily: 'Montserrat-M',fontSize: 16),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 21.5,
              //       ),
              //       Row(
              //         children: [
              //           Image.asset(
              //             'assets/images/gender1.png',
              //             width: 15,
              //             height: 16,
              //           ),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Text(
              //             widget.genderValue,
              //             style:TextStyle(
              //      fontFamily: 'Montserrat-M',fontSize: 16),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  _email() {
    if (widget?.contactModel?.email == null) {
      return Text(
        'Chưa cập nhật email',
        style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
      );
    }
    return Text(
      widget?.contactModel?.email,
      style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
    );
  }

  _buildSeenDetails(Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          right: 10,
          left: 20,
          top: 3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Xem chi tiết',
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }

  _buildTitle(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: AppColor.veryLightPinkFour,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      height: 40,
      padding: const EdgeInsets.only(left: 18),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Montserrat-M',
            color: AppColor.deepBlue,
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    );
  }
}
