import 'package:flutter/material.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:suns_med/shared/dialog/msg_dialog.dart';
import 'package:suns_med/src/Widgets/call/incoming_call.dart';
import 'package:suns_med/shared/call/call_workflow.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/is-app-sunsclinc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/appointment_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/cancel_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/input_appointment_model.dart';
import 'package:suns_med/src/account/notification/chat/detail_chat.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';
import 'package:suns_med/src/contacts/appointmenthistory/appointmenthistory_screen.dart';
import 'package:suns_med/src/appointment/detailappointment_screen.dart';
import 'package:suns_med/src/order/order_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/signup_signin/login/session_hotline_bloc.dart';
import 'package:suns_med/src/product/session_service_package_bloc.dart';

class ApponitmentDetail extends StatefulWidget {
  final String appointmentId, name;
  final AppointmentNewsModel appointmentNews;
  final int stateNumber;
  final AppointmentFilterQuery appointmentFilterQuery;
  ApponitmentDetail({
    this.appointmentNews,
    this.appointmentFilterQuery,
    this.appointmentId,
    this.name,
    this.stateNumber,
  });

  @override
  _ApponitmentDetailState createState() => _ApponitmentDetailState();
}

class _ApponitmentDetailState extends State<ApponitmentDetail> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  CancelAppointmentModel _cancelAppointment = CancelAppointmentModel();
  final bloc = AppointmentBloc();
  final blocHotline = HotlineBloc();
  final serviceBloc = ServicePackageBloc();

  String result = "Please scan the QR code or Barcode";

  var checkIsAppClinic = IsAppSunsClinic.isAppClinic;

  _checkTime(int time) {
    if (time < 11 && time >= 4) {
      return "sáng";
    } else if (time >= 11 && time < 14) {
      return "trưa";
    } else if (time >= 14 && time < 19) {
      return "chiều";
    } else if (time >= 19) {
      return "tối";
    }
  }

  _statusAppointment() {
    return BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
      bloc: bloc,
      builder: (output) {
        if (output.detailAppointment?.status == 1) {
          return Text(
            "Đã xác nhận",
            style: TextStyle(
              fontFamily: 'Montserrat-M',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.shamrockGreen,
            ),
          );
        } else if (output.detailAppointment?.status == 2) {
          return Text(
            "Đã huỷ",
            style: TextStyle(
              fontFamily: 'Montserrat-M',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.red,
            ),
          );
        } else {
          return Text(
            "Chờ xác nhận",
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.pumpkin),
          );
        }
      },
    );
  }

  @override
  void initState() {
    bloc.dispatch(LoadDetailAppointmentvent(id: this.widget.appointmentId));
    blocHotline.dispatch(EventGetHotline());
    if (bloc.state.appointmentNews == null ||
        bloc.state.appointmentNews.isEmpty) {
      // bloc.dispatch(EventLoadExamServices(id: this.widget.appointmentId));
      // bloc.dispatch(LoadRelationshipEvent());
      // bloc.dispatch(LoadContactEvent());
    }
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     bloc.dispatch(EventAddMoreExamServices(id: this.widget.appointmentId));
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Scaffold(
      appBar: const TopAppBar(),
      body: SingleChildScrollView(
        child: BlocProvider<AppointmentEvent, AppointmentState,
                AppointmentBloc>(
            bloc: bloc,
            builder: (state) {
              var detailAppointment = state.detailAppointment;

              var time = detailAppointment?.appointmentTime == null
                  ? ""
                  : DateFormat('kk:mm').format(
                      detailAppointment.appointmentTime,
                    );

              return (detailAppointment == null)
                  ? Center(
                      child: Text(language.notData),
                    )
                  : Column(
                      children: [
                        Stack(
                          children: [
                            CustomAppBar(
                              title:
                                  '${language.appointment}: ${detailAppointment?.code ?? ''}',
                              titleSize: 20,
                              isOrangeAppBar: true,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  top: 100, left: 25, right: 25),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF438BA7),
                                  Color(0xFF99438BA7)
                                ]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: RichText(
                                                  text: TextSpan(
                                                text:
                                                    '${detailAppointment?.name?.toUpperCase() ?? language.notPrescribed}',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat-M',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Text(
                                                  detailAppointment
                                                          ?.companyDepartmentName ??
                                                      '${language.center} ',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-M',
                                                      fontSize: 14,
                                                      color: Colors.white70)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5, right: 10),
                                              child: Text(
                                                  detailAppointment
                                                          ?.branchName ??
                                                      language.executionBranch,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-M',
                                                      fontSize: 14,
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              "STT: ${detailAppointment?.order ?? 0}" ??
                                                  "",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat-M',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          QrImage(
                                            backgroundColor: Colors.white,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            data:
                                                state.detailAppointment?.code ??
                                                    this
                                                        .widget
                                                        .appointmentNews
                                                        ?.code ??
                                                    "SUNS",
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.red)))),
                              onPressed: () {
                                if (widget?.appointmentNews?.staffUserId ==
                                    null) {
                                  MsgDialog.showMsgDialog(
                                      context,
                                      "Chat với bác sĩ",
                                      'Bác sĩ chưa có tài khoản');
                                } else
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailChat(
                                        // chatId: conversation.id,
                                        name:
                                            widget?.appointmentNews?.staffName,
                                        // image: conversation.image,
                                        userId: widget
                                            ?.appointmentNews?.staffUserId
                                            .toString(),
                                      ),
                                    ),
                                  );
                              },
                              child: Container(
                                width: 125,
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/imgclinic/ic_chat.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Chat',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            OutlinedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.red)))),
                              onPressed: () {
                                if (widget?.appointmentNews?.staffUserId ==
                                    null) {
                                  MsgDialog.showMsgDialog(
                                      context,
                                      "Gọi với bác sĩ",
                                      'Bác sĩ chưa có tài khoản');
                                } else
                                  _navigateInComming(CallInfo(
                                      id: widget?.appointmentNews?.staffUserId
                                          .toString(),
                                      name: widget?.name));
                              },
                              child: Container(
                                width: 125,
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/imgclinic/ic_call.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Video Call',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12, blurRadius: 10),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    language.dateOfExamination,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 14,
                                        color: Colors.black54),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      language.examTime,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 14,
                                          color: Colors.black54),
                                    ),
                                  ),
                                  Text(
                                    language.department,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 14,
                                        color: Colors.black54),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      language.doctor,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 14,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    detailAppointment?.appointmentTime == null
                                        ? DateFormat.yMd('vi')
                                            .format(DateTime.now())
                                        : DateFormat.yMd('vi').format(
                                            detailAppointment?.appointmentTime
                                                ?.toLocal()),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Montserrat-M',
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.darkPurple),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      // widget.appointmentNews
                                      detailAppointment
                                                  ?.isAppointmentDateTime ==
                                              true
                                          ? "$time ${_checkTime(detailAppointment?.appointmentTime?.hour)}"
                                          : "Không có giờ cố định",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.deepBlue),
                                    ),
                                  ),
                                  Text(
                                    state.detailAppointment
                                            ?.companyDepartmentName ??
                                        "",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.darkPurple),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      detailAppointment?.staffName ?? "",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.darkPurple),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailAppointmentScreen(
                                  serviceCosts: state.detailService.price,
                                  appointmentNewsModel: widget.appointmentNews,
                                  id: widget.appointmentId,
                                  name: widget.name,
                                ),
                              ),
                            );
                          },
                          child: BlocProvider<ServicePackageEvent,
                                  ServicePackageState, ServicePackageBloc>(
                              bloc: serviceBloc,
                              builder: (service) {
                                if (service.medicalTest.isEmpty ||
                                    service.medicalTest == null) {
                                  serviceBloc.dispatch(LoadDetailServiceEvent(
                                      servicePackageId:
                                          detailAppointment.servicePackageId,
                                      brandId: ''));
                                }
                                var serviceList = service.medicalTest;
                                return serviceList.isEmpty ||
                                        serviceList == null
                                    ? Container()
                                    : Container(
                                        margin:
                                            EdgeInsets.fromLTRB(25, 0, 25, 20),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 10),
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: Text(
                                                language.serviceList,
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat-M',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.darkPurple),
                                              ),
                                              trailing: Icon(
                                                  Icons.chevron_right_outlined),
                                            ),
                                            Wrap(
                                              children: List.generate(
                                                2,
                                                (index) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                bottom: 20),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/check-ring.png',
                                                              color: AppColor
                                                                  .deepBlue,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                serviceList[
                                                                        index]
                                                                    .name,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat-M',
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 0, 25, 20),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12, blurRadius: 10),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Text(
                              language.doctor,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.darkPurple),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      (detailAppointment?.staffImage != null)
                                          ? NetworkImage(
                                              detailAppointment.staffImage)
                                          : AssetImage(
                                              'assets/images/doctor-image.png'),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    detailAppointment?.staffName ??
                                        language.doctor,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        color: AppColor.darkPurple),
                                  ),
                                )
                              ],
                            ),
                            trailing: Icon(Icons.chevron_right_outlined),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (detailAppointment?.status == 1) {
                              Flushbar(
                                margin: EdgeInsets.all(8),
                                borderRadius: 8,
                                title: language.notification,
                                message: AppLocalizations.of(context)
                                    .notChangeAppointment,
                                duration: Duration(seconds: 3),
                              )..show(context);
                            } else if (detailAppointment?.status == 2) {
                              Flushbar(
                                margin: EdgeInsets.all(8),
                                borderRadius: 8,
                                title: language.notification,
                                message: AppLocalizations.of(context)
                                    .cancelAppointmentDone,
                                duration: Duration(seconds: 3),
                              )..show(context);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderScreen(
                                          appointmentFilterQuery:
                                              widget.appointmentFilterQuery,
                                          stateNumber: widget.stateNumber,
                                          appointmentId: widget.appointmentId,
                                          useStaff:
                                              state.detailService.useStaff,
                                          companyId:
                                              state.detailAppointment.companyId,
                                          servicePackageId: state
                                              .detailAppointment
                                              .servicePackageId,
                                          isReschedule: true,
                                          branchId:
                                              state.detailAppointment.branchId,
                                        )),
                              );
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(25, 0, 25, 20),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 10),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Text(
                                language.changeAppointment,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.darkPurple),
                              ),
                              title: Row(
                                children: [
                                  // CircleAvatar(
                                  //   backgroundImage:
                                  //       NetworkImage(detailAppointment.staffImage),
                                  // )
                                ],
                              ),
                              trailing: Icon(Icons.chevron_right_outlined),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: state.detailAppointment?.status == 2
                              ? () {
                                  Flushbar(
                                    margin: EdgeInsets.all(8),
                                    borderRadius: 8,
                                    title: language.notification,
                                    message: AppLocalizations.of(context)
                                        .cancelledAppoinntment,
                                    duration: Duration(seconds: 3),
                                  )..show(context);
                                }
                              : state.detailAppointment?.status == 1
                                  ? () {
                                      Flushbar(
                                        margin: EdgeInsets.all(8),
                                        borderRadius: 8,
                                        title: language.notification,
                                        message: AppLocalizations.of(context)
                                            .notCancelAppointment,
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    }
                                  : () => _showAlert(context, ""),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(25, 0, 25, 20),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 10),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Text(
                                language.cancelAppointment,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.deepBlue),
                              ),
                              title: Row(
                                children: [],
                              ),
                              trailing: Icon(Icons.chevron_right_outlined),
                            ),
                          ),
                        ),
                        BlocProvider<HotlineEvent, HotlineState, HotlineBloc>(
                          bloc: blocHotline,
                          builder: (state) {
                            String hotline = state.hotline ?? '0932108534';
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              width: 190,
                              height: 35,
                              child: OutlinedButton(
                                onPressed: () {
                                  launch("tel://$hotline");
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.red)))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/imgclinic/ic_phone.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .callHotline,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
            }),
      ),
    );
  }

  Future _showAlert(BuildContext context, String message) async {
    return showDialog(
      context: context,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.only(top: 14),
          height: 200,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(11),
          //   color: AppColor.white,
          // ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    AppLocalizations.of(context).enterReason,
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: TextFormField(
                    maxLines: 4,
                    onChanged: (t) {
                      setState(() {
                        _cancelAppointment.reason = t;
                      });
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return AppLocalizations.of(context).reasonNotEmpty;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: "${AppLocalizations.of(context).reason}...",
                      contentPadding:
                          const EdgeInsets.only(left: 14.0, top: 9.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        bloc.dispatch(EventCancelAppointment(
                          appointmentId: widget.appointmentId,
                          cancelAppointment: _cancelAppointment,
                        ));
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("OK",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 16,
                            color: AppColor.deepBlue)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _navigateInComming(CallInfo callInfo) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => InCommingCall(
          info: CommingCallInfo(
            isInCommingCall: false,
            receiver: callInfo,
          ),
        ),
      ),
    );
  }
}
