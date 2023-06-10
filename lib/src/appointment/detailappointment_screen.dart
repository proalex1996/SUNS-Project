import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/input_appointment_model.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';
import 'package:suns_med/src/order/session_confirminfo_bloc.dart';
import 'package:shimmer/shimmer.dart';

class DetailAppointmentScreen extends StatefulWidget {
  final AppointmentNewsModel appointmentNewsModel;
  final String id;
  final String name;
  final int serviceCosts;
  DetailAppointmentScreen({
    this.appointmentNewsModel,
    this.id,
    this.name,
    this.serviceCosts,
  });
  @override
  _DetailAppointmentScreenState createState() =>
      _DetailAppointmentScreenState();
}

class _DetailAppointmentScreenState extends State<DetailAppointmentScreen> {
  final bloc = AppointmentBloc();
  final confirmBloc = ConfirmBloc();
  ScrollController _scrollController = ScrollController();
  var inputFormat = DateFormat('HH:mm dd/MM/yyyy');

  @override
  void initState() {
    bloc.dispatch(LoadDetailAppointmentvent(id: this.widget.id));
    bloc.dispatch(EventLoadExamServices(id: this.widget.id));
    if (bloc.state.appointmentNews == null ||
        bloc.state.appointmentNews.isEmpty) {
      // bloc.dispatch(LoadRelationshipEvent());
      // bloc.dispatch(LoadContactEvent());
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.dispatch(EventAddMoreExamServices(id: this.widget.id));
      }
    });
    super.initState();
  }

  final money = NumberFormat('#,###,000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.veryLightPinkFour,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Danh sách dịch vụ',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
        backgroundColor: AppColor.deepBlue,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
                bloc: bloc,
                builder: (state) {
                  return Container(
                    height: MediaQuery.of(context).size.height * .13,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Mã:',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0175),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      state.detailAppointment?.code ?? "",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0175),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Tên:',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0175),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget?.name ?? "",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0175),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Giờ khám:',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      state.detailAppointment
                                                  ?.appointmentTime ==
                                              null
                                          ? DateFormat.yMd('vi')
                                              .format(DateTime.now())
                                          : state.detailAppointment
                                                      ?.isAppointmentDateTime ==
                                                  false
                                              ? DateFormat.yMd('vi').format(
                                                  state?.detailAppointment
                                                      ?.appointmentTime
                                                      ?.toLocal())
                                              : DateFormat.yMd('vi')
                                                  .add_Hm()
                                                  .format(state
                                                      ?.detailAppointment
                                                      ?.appointmentTime
                                                      ?.toLocal()),
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0175),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Chi phí dịch vụ:',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0175),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${money.format(widget.serviceCosts)}" ??
                                          "",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0175),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            // SizedBox(
            //   height: 10,
            // ),
            _getAppointment()
          ],
        ),
      ),
    );
  }

  _getAppointment() {
    return BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
      bloc: bloc,
      builder: (output) {
        var examServices = output.examService.data;
        return Container(
          margin: EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Wrap(
            children: List.generate(
              examServices.length,
              (index) {
                var examService = examServices[index];

                return examServices == null || examServices.isEmpty
                    ? Container(
                        child: Center(
                          child: Text('Không có dữ liệu'),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300]),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/check-ring.png',
                              color: AppColor.deepBlue,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  examService.name,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: AppColor.darkPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
          ),
        );
      },
    );
  }

  // _getDetailAppointment() {
  //   return BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
  //       bloc: bloc,
  //       builder: (output) {
  //         // var checkState = output.appointmentNews == null;

  //         return Container(
  //           margin: EdgeInsets.only(top: 20, left: 21, right: 21),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             boxShadow: [
  //               BoxShadow(blurRadius: 6, color: Colors.black12),
  //             ],
  //           ),
  //           padding:
  //               const EdgeInsets.only(top: 22, left: 20, right: 20, bottom: 10),
  //           child: Column(
  //             children: [
  //               Row(
  //                 // crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     'SỐ THỨ TỰ KHÁM:',
  //                     style:TextStyle(
  //      fontFamily: 'Montserrat-M',
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: AppColor.deepBlue,
  //                     ),
  //                   ),
  //                   Text(
  //                     '${output.detailAppointment?.order ?? 0}',
  //                     style:TextStyle(
  //    fontFamily: 'Montserrat-M',
  //                         fontSize: 30,
  //                         fontWeight: FontWeight.bold,
  //                         color: AppColor.deepBlue),
  //                   )
  //                 ],
  //               ),
  //               output.detailAppointment?.currentOrder == null ||
  //                       output.detailAppointment?.currentOrder == 0
  //                   ? Container()
  //                   : Center(
  //                       child: Text(
  //                         "Số khám hiện tại: ${output.detailAppointment?.currentOrder.toString()}",
  //                         style:TextStyle(
  // fontFamily: 'Montserrat-M',
  //                             fontWeight: FontWeight.bold, fontSize: 20),
  //                       ),
  //                     ),
  //               Container(
  //                 padding: const EdgeInsets.only(top: 15, bottom: 10),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'THÔNG TIN BỆNH NHÂN',
  //                       style:TextStyle(
  //     fontFamily: 'Montserrat-M',
  //                         fontSize: 16,
  //                         color: AppColor.pumpkin,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           'Họ và tên:',
  //                           style:TextStyle(
  //    fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         Text(
  //                           // output.detailAppointment.code.toString(),
  //                           widget?.name ?? "",
  //                           style:TextStyle(
  //  fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           'Mã booking :',
  //                           style:TextStyle(
  //  fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         Text(
  //                           widget?.appointmentNewsModel?.code ?? "",
  //                           style:TextStyle(
  //   fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           'Ngày, giờ khám :',
  //                           style:TextStyle(
  //   fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         Text(
  //                           output.detailAppointment?.isAppointmentDateTime ==
  //                                   false
  //                               ? DateFormat.yMd('vi').format(widget
  //                                   ?.appointmentNewsModel?.appointmentTime
  //                                   ?.toLocal())
  //                               : DateFormat.yMd('vi').add_Hm().format(widget
  //                                   ?.appointmentNewsModel?.appointmentTime
  //                                   ?.toLocal()),
  //                           style:TextStyle(
  //    fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           'Còn lại :',
  //                           style:TextStyle(
  //   fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         Text(
  //                           output.detailAppointment?.countDownDay == 0 &&
  //                                   output.detailAppointment?.countDownHour ==
  //                                       null
  //                               ? ""
  //                               : output.detailAppointment?.countDownDay == 0 &&
  //                                       output.detailAppointment
  //                                               ?.countDownHour !=
  //                                           null
  //                                   ? '${output.detailAppointment?.countDownHour} Giờ'
  //                                   : output.detailAppointment?.countDownHour ==
  //                                               null ||
  //                                           output.detailAppointment
  //                                                   ?.countDownHour ==
  //                                               0
  //                                       ? '${output.detailAppointment?.countDownDay} Ngày'
  //                                       : '${output.detailAppointment?.countDownDay} Ngày ${output.detailAppointment?.countDownHour} Giờ ',
  //                           style:TextStyle(
  //     fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           'Trạng thái:',
  //                           style:TextStyle(
  // fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         _statusAppointment(),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Text(
  //                       'Ghi chú:',
  //                       style:TextStyle(
  //         fontFamily: 'Montserrat-M',
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 9,
  //                     ),
  //                     _note(),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Text(
  //                       'Tiền sử:',
  //                       style:TextStyle(
  //         fontFamily: 'Montserrat-M',
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 7,
  //                     ),
  //                     _firstHistory(),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Text(
  //                       'Toa thuốc hiện tại:',
  //                       style:TextStyle(
  //           fontFamily: 'Montserrat-M',
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     _phamacyUrl(),
  //                     SizedBox(
  //                       height: 30,
  //                     ),
  //                     Text(
  //                       'THÔNG TIN BÁC SĨ',
  //                       style:TextStyle(
  //            fontFamily: 'Montserrat-M',
  //                         fontSize: 16,
  //                         color: AppColor.pumpkin,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           'Họ và tên:',
  //                           style:TextStyle(
  //        fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         Text(
  //                           output?.detailAppointment?.staffName ?? "",
  //                           style:TextStyle(
  //          fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           'Số điện thoại:',
  //                           style:TextStyle(
  //            fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         Text(
  //                           output?.detailAppointment?.staffPhone ?? "",
  //                           style:TextStyle(
  //         fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           'Email:',
  //                           style:TextStyle(
  //         fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         Text(
  //                           output?.detailAppointment?.staffEmail ?? "",
  //                           style:TextStyle(
  //         fontFamily: 'Montserrat-M',
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Text(
  //                       'Liên hệ với bác sĩ:',
  //                       style:TextStyle(
  //             fontFamily: 'Montserrat-M',
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   RaisedButton(
  //                     color: AppColor.pumpkin,
  //                     onPressed: () {},
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Image.asset(
  //                           'assets/images/speak.png',
  //                           width: 26,
  //                           height: 21,
  //                         ),
  //                         SizedBox(
  //                           width: 10.5,
  //                         ),
  //                         Text(
  //                           'Chat',
  //                           style:TextStyle(
  //          fontFamily: 'Montserrat-M',fontSize: 15, color: Colors.white),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   RaisedButton(
  //                     color: AppColor.trueGreen,
  //                     onPressed: () {},
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Image.asset(
  //                           'assets/images/video.png',
  //                           width: 23,
  //                           height: 16,
  //                         ),
  //                         SizedBox(
  //                           width: 6.7,
  //                         ),
  //                         Text(
  //                           'Video',
  //                           style:TextStyle(
  //          fontFamily: 'Montserrat-M',fontSize: 15, color: Colors.white),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 child: RaisedButton(
  //                   onPressed: output.detailAppointment?.orderId != null
  //                       ? output.order?.isPaid == true ||
  //                               output.order?.paymentMethod == 8 &&
  //                                   output.order?.isPaid == false
  //                           ? null
  //                           : () {
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (context) => BillOrderScreen(
  //                                     idOrder: output.order.id,
  //                                     appointmentId: this.widget.id,
  //                                   ),
  //                                 ),
  //                               );
  //                             }
  //                       : null,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   color: AppColor.deepBlue,
  //                   child: Text(
  //                     "Thanh toán",
  //                     style:TextStyle(
  //              fontFamily: 'Montserrat-M',color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  // _showAlert(BuildContext context, String message, String img) async {
  //   return showDialog(
  //     context: context,
  //     child: Dialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //         child: Container(
  //           // padding: const EdgeInsets.all(10),
  //           // height: do,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(11),
  //             color: AppColor.white,
  //           ),
  //           child: PhotoView(imageProvider: NetworkImage(img)),
  //         )),
  //   );
  // }

  // _statusAppointment() {
  //   return BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
  //     bloc: bloc,
  //     builder: (output) {
  //       if (output.detailAppointment?.status == 1) {
  //         return Text(
  //           "Đã xác nhận",
  //           style:TextStyle(
  //                    fontFamily: 'Montserrat-M',
  //             fontSize: 16,
  //             color: AppColor.shamrockGreen,
  //           ),
  //         );
  //       } else if (output.detailAppointment?.status == 2) {
  //         return Text(
  //           "Đã huỷ",
  //           style:TextStyle(
  //                  fontFamily: 'Montserrat-M',
  //             fontSize: 16,
  //             color: AppColor.red,
  //           ),
  //         );
  //       } else {
  //         return Text(
  //           "Chờ xác nhận",
  //           style:TextStyle(
  //              fontFamily: 'Montserrat-M',fontSize: 16, color: AppColor.orangeColor),
  //         );
  //       }
  //     },
  //   );
  // }

  // _note() {
  //   return BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
  //     bloc: bloc,
  //     builder: (output) {
  //       if (output?.detailAppointment?.note == null ||
  //           output.detailAppointment.note.isEmpty) {
  //         return Text(
  //           "Chưa có ghi chú",
  //           style:TextStyle(
  //                      fontFamily: 'Montserrat-M',
  //             fontSize: 13,
  //           ),
  //         );
  //       } else {
  //         return Text(
  //           output?.detailAppointment?.note,
  //           style:TextStyle(
  //                fontFamily: 'Montserrat-M',
  //             fontSize: 13,
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  // _firstHistory() {
  //   return BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
  //     bloc: bloc,
  //     builder: (output) {
  //       if (output?.detailAppointment?.firstHistory == null ||
  //           output.detailAppointment.firstHistory.isEmpty) {
  //         return Text(
  //           "Chưa có tiền sử",
  //           style:TextStyle(
  //                fontFamily: 'Montserrat-M',
  //             fontSize: 13,
  //           ),
  //         );
  //       } else {
  //         return Text(
  //           output?.detailAppointment?.firstHistory,
  //           style:TextStyle(
  //                fontFamily: 'Montserrat-M',
  //             fontSize: 13,
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  // _phamacyUrl() {
  //   return BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
  //     bloc: bloc,
  //     builder: (output) {
  //       if (output?.detailAppointment?.prescription == null) {
  //         return Text(
  //           "Chưa có toa thuốc",
  //           style:TextStyle(
  //                fontFamily: 'Montserrat-M',
  //             fontSize: 13,
  //           ),
  //         );
  //       } else {
  //         return Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               height: 300,
  //               width: 200,
  //               child: GestureDetector(
  //                   onTap: () => _showAlert(context, "message",
  //                       output?.detailAppointment?.prescription),
  //                   child:
  //                       Image.network(output?.detailAppointment?.prescription)),
  //             ),
  //             Icon(Icons.search),
  //           ],
  //         );
  //       }
  //     },
  //   );
  // }

}
