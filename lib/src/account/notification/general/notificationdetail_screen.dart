import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/notification/dto/detail_notification.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/notification/dto/notify_model.dart';
import 'package:html/dom.dart' as dom;
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotifyDetailScreen extends StatefulWidget {
  final NotifyModel notifyModel;
  final NotificationAppointmentRejectData notificationAppointmentRejectData;
  final NotificationAppointmentRemindData notificationAppointmentRemindData;
  final String notificationId;
  final DetailNotificationModel notification;

  const NotifyDetailScreen(
      {Key key,
      this.notification,
      this.notificationId,
      this.notifyModel,
      this.notificationAppointmentRejectData,
      this.notificationAppointmentRemindData})
      : super(key: key);

  @override
  _NotifyDetailScreenState createState() => _NotifyDetailScreenState();
}

class _NotifyDetailScreenState extends State<NotifyDetailScreen> {
  final bloc = NotificationBloc();
  final detailCompanyBloc = DetailItemBloc();
  final appointmentBloc = AppointmentBloc();
  final notifyBloc = NotificationBloc();
  // bool _isAppointmentRequestReject = false;
  @override
  void dispose() {
    notifyBloc.dispatch(CountNotifyEvent());
    bloc.dispatch(LoadGeneralEvent());

    super.dispose();
  }

  @override
  void initState() {
    var appointmentId = _getAppointmentRequestRejectId();

    if (appointmentId != null && appointmentId.isNotEmpty) {
      // _isAppointmentRequestReject = true;
      appointmentBloc.dispatch(LoadDetailAppointmentvent(id: appointmentId));
      appointmentBloc
          .dispatch(AllowAcceptRequestRejectEvent(id: appointmentId));
    }

    if (widget.notifyModel != null) {
      if (widget.notifyModel.isRead == false) {
        bloc.dispatch(MarkReadNotifyEvent(id: widget?.notifyModel?.id));
      } else if (widget.notificationAppointmentRejectData != null) {
        if (widget.notificationAppointmentRejectData.type == 1) {
          detailCompanyBloc.dispatch(LoadDetailDoctorEvent(
              id: widget.notificationAppointmentRejectData?.companyId));
        } else if (widget.notificationAppointmentRejectData.type == 2) {
          detailCompanyBloc.dispatch(LoadDetailClinicEvent(
              id: widget.notificationAppointmentRejectData?.companyId));
        } else if (widget.notificationAppointmentRejectData.type == 3) {
          detailCompanyBloc.dispatch(LoadDetailHospitalEvent(
              id: widget.notificationAppointmentRejectData?.companyId));
        }
      }
    } else {
      //Todo refactor
    }
    super.initState();
  }

  String _getAppointmentRequestRejectId() {
    if (widget.notification?.type == "Notify.Appointment.Request.Reject" &&
        widget.notification.dataExtensionType ==
            "NotificationAppointmentRejectData" &&
        widget.notification.dataExtension != null) {
      var data = jsonDecode(widget.notification.dataExtension);

      return data["id"];
    } else if (widget.notifyModel?.type ==
            "Notify.Appointment.Request.Reject" &&
        widget.notifyModel.dataExtensionType ==
            "NotificationAppointmentRejectData" &&
        widget.notifyModel.dataExtension != null) {
      var data = jsonDecode(widget.notifyModel.dataExtension);

      return data["id"];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.veryLightPinkFour,
      // appBar: AppBar(
      //   toolbarHeight: height(context) * 0.15,
      //   backgroundColor: AppColor.deepBlue,
      //   flexibleSpace: Padding(
      //     padding: EdgeInsets.fromLTRB(
      //         width(context) * 0.58, height(context) * 0.1, 0, 0),
      //     child: Container(
      //       decoration: BoxDecoration(
      //         image: DecorationImage(
      //           image:
      //               AssetImage('assets/images/profile/pattern_part_circle.png'),
      //           fit: BoxFit.none,
      //         ),
      //       ),
      //     ),
      //   ),
      //   title: Text(
      //     AppLocalizations.of(context).noticeDetails,
      //     style: TextStyle(fontSize: 18, color: Colors.white),
      //   ),
      //   leading: BlocProvider<NotificationEvent, NotificationState,
      //       NotificationBloc>(
      //     bloc: notifyBloc,
      //     builder: (state) {
      //       return IconButton(
      //           icon: Icon(Icons.arrow_back),
      //           onPressed: () {
      //             notifyBloc.dispatch(CountNotifyEvent());
      //             Navigator.pop(context);
      //           });
      //     },
      //   ),
      //   centerTitle: true,
      // ),
      appBar: const TopAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(
              title: AppLocalizations.of(context).noticeDetails,
              titleSize: 18,
            ),
            _buildTitle(),
            // _buildContent(),
            _buildAppointmentReject(),
            // _buildAppointmentRemind()
          ],
        ),
      ),
    );
  }

  _buildTitle() {
    return Container(
      color: Colors.white,
      height: height(context),
      width: width(context),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.notifyModel?.title,
              overflow: TextOverflow.fade,
              maxLines: 2,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 16,
                  color: AppColor.darkPurple,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              DateFormat.yMd('vi').add_Hms().format(
                  DateTime.parse(widget.notifyModel?.createdTime.toString())),
              style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 13,
                color: AppColor.veryLightPinkTwo,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              '${widget.notifyModel?.content ?? ''}',
              style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 14,
                color: AppColor.darkPurple,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  _buildContent() {
    if (widget.notifyModel?.dataExtensionType == "") {
      return Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Html(
          data: widget.notifyModel?.content ?? "",
          defaultTextStyle: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 14, color: Colors.black),
          padding: EdgeInsets.all(10.0),
          onLinkTap: (url) {
            print("Opening $url...");
          },
          customRender: (node, children) {
            if (node is dom.Element) {
              switch (node.localName) {
                case "custom_tag": // using this, you can handle custom tags in your HTML
                  return Column(children: children);
              }
            }
            return null;
          },
        ),
      );
    }
    // return Container(
    //   margin: EdgeInsets.only(top: 10),
    //   padding: const EdgeInsets.all(10),
    //   color: Colors.white,
    //   child: Text(
    //     widget.notifyModel?.content,
    //     style: TextStyle(fontSize: 14, color: Colors.black),
    //   ),
    // );
    return Container();
  }

  _buildAppointmentReject() {
    if (widget.notifyModel?.dataExtensionType ==
        "NotificationAppointmentRejectData") {
      return BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
          bloc: appointmentBloc,
          builder: (state) {
            var detailAppointment = state.detailAppointment;

            var time = detailAppointment?.appointmentTime == null
                ? ""
                : DateFormat('kk:mm').format(
                    detailAppointment.appointmentTime,
                  );

            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.white,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ngày khám",
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.0175,
                                  color: Colors.black54),
                            ),
                            Text(
                              detailAppointment?.appointmentTime == null
                                  ? DateFormat.yMd('vi').format(DateTime.now())
                                  : DateFormat.yMd('vi').format(
                                      detailAppointment?.appointmentTime
                                          ?.toLocal()),
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.0175,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Giờ khám",
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.0175,
                                  color: Colors.black54),
                            ),
                            Text(
                              // widget.appointmentNews
                              detailAppointment?.isAppointmentDateTime == true
                                  ? "$time (${_checkTime(detailAppointment?.appointmentTime?.hour)})"
                                  : "Không có giờ cố định",
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.0175,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.shamrockGreen),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Phòng ban",
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.0175,
                                  color: Colors.black54),
                            ),
                            Text(
                              state.detailAppointment?.companyDepartmentName ??
                                  "",
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.0175,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bác sĩ",
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.0175,
                                  color: Colors.black54),
                            ),
                            Flexible(
                              child: Text(
                                detailAppointment?.staffName ?? "",
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.0175,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 20 / 812),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 40 / 812,
                        width: MediaQuery.of(context).size.width * 300 / 375,
                        child: RaisedButton(
                          color: state.allowedAcceptRequestReject == true
                              ? AppColor.deepBlue
                              : AppColor.white,
                          onPressed: () {
                            if (state.allowedAcceptRequestReject == true) {
                              var appointmentId =
                                  _getAppointmentRequestRejectId();

                              if (appointmentId != null &&
                                  appointmentId.isNotEmpty) {
                                // _isAppointmentRequestReject = true;
                                appointmentBloc.dispatch(
                                    LoadDetailAppointmentvent(
                                        id: appointmentId));
                                appointmentBloc.dispatch(
                                    AllowAcceptRequestRejectEvent(
                                        id: appointmentId));
                              }
                              appointmentBloc.dispatch(
                                  AcceptRequestRejectEvent(id: appointmentId));
                              Navigator.pop(context);
                            } else {
                              return null;
                            }
                          },
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Text(
                            'Xác nhận',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                color: state.allowedAcceptRequestReject == true
                                    ? AppColor.white
                                    : AppColor.deepBlue,
                                fontSize: MediaQuery.of(context).size.height *
                                    16 /
                                    812),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.only(top: 21),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       Container(
                //         width: MediaQuery.of(context).size.width * 167/375,
                //         child: RaisedButton(
                //           color: AppColor.deepBlue,
                //           onPressed: () {
                //             Navigator.pop(context);
                //           },
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(26),
                //           ),
                //           child: Text(
                //             'Xác nhận',
                //             style: TextStyle(color: Colors.white, fontSize: 16),
                //           ),
                //         ),
                //       ),
                //       Container(
                //         width: MediaQuery.of(context).size.width * 167/375,
                //         child: RaisedButton(
                //           color: AppColor.pumpkin,
                //           onPressed: () {},
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(26),
                //           ),
                //           child: Text(
                //             'Huỷ',
                //             style: TextStyle(color: Colors.white, fontSize: 16),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            );
          });
    }
    return Container();
  }

  _checkTime(int time) {
    if (time < 11 && time >= 4) {
      return "Buổi sáng";
    } else if (time >= 11 && time < 14) {
      return "Buổi trưa";
    } else if (time >= 14 && time < 19) {
      return "Buổi chiều";
    } else if (time >= 19) {
      return "Buổi tối";
    }
  }

  // _buildAppointmentReject() {
  //   if (widget.notifyModel?.dataExtensionType ==
  //       "NotificationAppointmentRejectData") {
  //     return BlocProvider<DetailItemEvent, DetailItemState, DetailItemBloc>(
  //         bloc: detailCompanyBloc,
  //         builder: (state) {
  //           return Container(
  //             margin: EdgeInsets.only(top: 10),
  //             padding: const EdgeInsets.all(10),
  //             color: Colors.white,
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: <Widget>[
  //                     _renderImage(
  //                       state.detailDHC?.logoImage,
  //                     ),
  //                     // Image.network(
  //                     //   // widget.notifyModel?.appointment?.clinic?.avatar,
  //                     //   state.detailDHC?.logoImage,
  //                     //   width: 81,
  //                     //   height: 81,
  //                     // ),
  //                     SizedBox(
  //                       width: 15,
  //                     ),
  //                     Flexible(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: <Widget>[
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 widget.notificationAppointmentRejectData
  //                                             ?.type ==
  //                                         1
  //                                     ? "Bác sĩ: "
  //                                     : widget.notificationAppointmentRejectData
  //                                                 ?.type ==
  //                                             2
  //                                         ? "Phòng khám: "
  //                                         : "Bệnh viện: ",
  //                                 style: TextStyle(
  //                                   fontSize: 16,
  //                                   color: Colors.black,
  //                                 ),
  //                               ),
  //                               Flexible(
  //                                 child: Text(
  //                                   state.detailDHC?.name ?? "",
  //                                   overflow: TextOverflow.ellipsis,
  //                                   style: TextStyle(
  //                                     fontSize: 16,
  //                                     color: AppColor.deepBlue,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 8,
  //                           ),
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 'Chuyên khoa: ',
  //                                 style: TextStyle(
  //                                   fontSize: 16,
  //                                   color: AppColor.greyishBrown,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 state.detailDHC?.specialized ?? "",
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: TextStyle(
  //                                   fontSize: 16,
  //                                   color: AppColor.greyishBrown,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 17,
  //                           ),
  //                           Text(
  //                             "Lý do: ${widget.notificationAppointmentRejectData.reason}",
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               color: AppColor.greyishBrown,
  //                             ),
  //                             textAlign: TextAlign.center,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Divider(
  //                   height: 40,
  //                   thickness: 1,
  //                 ),
  //                 Text(
  //                   'Bạn có thể chọn bác sĩ cùng chuyên khoa để lịch khám được tiếp tục',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Colors.black,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 // _buildListDoctor(state),
  //               ],
  //             ),
  //           );
  //         });
  //   }
  //   return Container();
  // }

  // _buildListDoctor(DetailItemState detailItemState) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height / 2.05,
  //     child: ListView.builder(
  //       itemCount: detailItemState.listCompanySimilar?.length ?? 0,
  //       itemBuilder: (build, index) {
  //         var data = detailItemState.listCompanySimilar[index];
  //         if (data.type == 0 || data.type == 4) {
  //           return SizedBox();
  //         } else {
  //           return Stack(
  //             children: <Widget>[
  //               Container(
  //                 margin: EdgeInsets.all(5),
  //                 width: MediaQuery.of(context).size.width * 0.95,
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(7),
  //                     color: Colors.white,
  //                     boxShadow: [
  //                       BoxShadow(
  //                           color: Colors.black26,
  //                           blurRadius: 4,
  //                           offset: Offset(0, 0))
  //                     ]),
  //                 padding: const EdgeInsets.all(15),
  //                 child: Row(
  //                   children: <Widget>[
  //                     Column(
  //                       children: <Widget>[
  //                         _renderImage(data?.image),
  //                         SizedBox(
  //                           height: 10,
  //                         ),
  //                         StarRating(
  //                           color: Color(0xffffd500),
  //                           enable: false,
  //                           rating: data?.rating ?? 0.0,
  //                           starCount: 5,
  //                           size: 15,
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       width: 15,
  //                     ),
  //                     Flexible(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: <Widget>[
  //                           Text(
  //                             data?.name ?? "",
  //                             overflow: TextOverflow.ellipsis,
  //                             style: TextStyle(
  //                               fontSize: 15,
  //                               color: Colors.black,
  //                             ),
  //                           ),
  //                           Divider(
  //                             height: 18,
  //                           ),
  //                           Row(
  //                             children: <Widget>[
  //                               Image.asset(
  //                                 'assets/images/ic_doctor2.png',
  //                                 width: 10.4,
  //                                 height: 12,
  //                               ),
  //                               SizedBox(
  //                                 width: 7.1,
  //                               ),
  //                               Text(
  //                                 data?.specialized ?? "Đa khoa",
  //                                 style: TextStyle(
  //                                   fontSize: 13,
  //                                   color: Color(0xff515151),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 8,
  //                           ),
  //                           Row(
  //                             children: <Widget>[
  //                               Image.asset(
  //                                 'assets/images/ic_location2.png',
  //                                 width: 10.4,
  //                                 height: 12,
  //                               ),
  //                               SizedBox(
  //                                 width: 8.9,
  //                               ),
  //                               Flexible(
  //                                 child: Text(
  //                                   data?.address ?? "",
  //                                   style: TextStyle(
  //                                     fontSize: 13,
  //                                     color: Color(0xff515151),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 17,
  //                           ),
  //                           Row(
  //                             children: <Widget>[
  //                               Image.asset(
  //                                 'assets/images/ic_heart.png',
  //                                 width: 14.1,
  //                                 height: 12.5,
  //                               ),
  //                               SizedBox(
  //                                 width: 4.8,
  //                               ),
  //                               Text(
  //                                 data.totalLike?.toString() ?? "",
  //                                 style: TextStyle(
  //                                   fontSize: 13,
  //                                   color: Color(0xff515151),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: -5,
  //                 right: 10,
  //                 child: RaisedButton(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(11),
  //                   ),
  //                   color: AppColor.deepBlue,
  //                   onPressed: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (ctx) => DetailHospitalItemScreen(
  //                           id: data?.id,
  //                           type: data?.type == 1
  //                               ? CompanyType.Doctor
  //                               : data?.type == 2
  //                                   ? CompanyType.Clinic
  //                                   : CompanyType.Hospital,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   child: Row(
  //                     children: <Widget>[
  //                       Image.asset(
  //                         'assets/images/ic_calendar.png',
  //                         width: 15.2,
  //                         height: 15.2,
  //                       ),
  //                       SizedBox(
  //                         width: 6.8,
  //                       ),
  //                       Text(
  //                         'Đặt lịch khám',
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

  _renderImage(String image) {
    Widget result;
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
                image: AssetImage('assets/images/doctor2.png'),
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
              image: AssetImage('assets/images/doctor2.png'),
            ),
          ),
        ),
      );
    }

    return result;
  }

  _buildAppointmentRemind() {
    if (widget.notifyModel?.dataExtensionType ==
        "NotificationAppointmentRemindData") {
      return BlocProvider<DetailItemEvent, DetailItemState, DetailItemBloc>(
          bloc: detailCompanyBloc,
          builder: (state) {
            return Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(21),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      _renderImage(
                        state.detailDHC?.logoImage,
                      ),
                      // Image.network(
                      //   state.detailDHC?.logoImage,
                      //   width: 80,
                      //   height: 80,
                      // ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                'Bác sĩ: ',
                                style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                state.detailDHC?.name ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                  color: AppColor.deepBlue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                'Chuyên khoa: ',
                                style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                  color: AppColor.greyishBrown,
                                ),
                              ),
                              Text(
                                state.detailDHC?.specialized ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                  color: AppColor.greyishBrown,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 53,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.deepBlue,
                        maxRadius: 12,
                        child: Image.asset(
                          'assets/images/ic_location2.png',
                          width: 10.4,
                          height: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Địa điểm',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 15,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            state.detailDHC?.address ?? "",
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 13,
                              color: Color(0xff515151),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.deepBlue,
                        maxRadius: 12,
                        child: Image.asset(
                          'assets/images/ic_calendar.png',
                          width: 10.4,
                          height: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ngày khám',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 15,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${widget.notificationAppointmentRemindData?.appointmentDate}",
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 13,
                              color: Color(0xff515151),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.deepBlue,
                        maxRadius: 12,
                        child: Image.asset(
                          'assets/images/ic_calendar.png',
                          width: 10.4,
                          height: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khung thời gian',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 15,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${DateFormat('kk:mm:ss').format(widget.notificationAppointmentRemindData?.appointmentDate)}",
                            style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 13,
                              color: Color(0xff515151),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 21),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 167,
                          child: RaisedButton(
                            color: AppColor.deepBlue,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Text(
                              'Xác nhận',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        Container(
                          width: 153,
                          child: RaisedButton(
                            color: AppColor.pumpkin,
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Text(
                              'Huỷ',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }

    return Container();
  }
}
