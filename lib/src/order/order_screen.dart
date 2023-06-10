import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/calendar_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/appointment_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/reschedule_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/staff_model.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';
import 'package:suns_med/src/appointment/session_reschedule_bloc.dart';
import 'package:suns_med/src/order/createinfor_screen.dart';
import 'package:suns_med/src/order/session_order_bloc.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/Widgets/choose_doctor.dart';
import 'package:suns_med/src/Widgets/choose_time.dart';

import 'package:suns_med/src/Widgets/tableCalendar.dart';
import 'package:suns_med/src/order/choosefile_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/shared/dialog/msg_dialog.dart';

class OrderScreen extends StatefulWidget {
  final Function onClick;
  final CompanyType companyType;
  final String companyId,
      address,
      companyName,
      servicePackageId,
      appointmentId,
      branchId;
  final bool useBookingTime, isReschedule, useStaff;
  final int stateNumber;
  final int fromAge, toAge, gender;
  final AppointmentFilterQuery appointmentFilterQuery;
  final ContactModel contact;

  OrderScreen(
      {this.onClick,
      this.stateNumber,
      this.address,
      this.companyId,
      this.companyType,
      this.companyName,
      this.useStaff,
      this.useBookingTime,
      this.servicePackageId,
      this.appointmentId,
      this.appointmentFilterQuery,
      @required this.isReschedule,
      this.fromAge,
      this.toAge,
      this.gender,
      this.contact,
      this.branchId});
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  CalendarController calendarController;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime dateTime = DateTime.now();
  DateTime dateTimeSelect;
  var _isVisibleContinueButton = false;
  bool isSelected = false;

  final bloc = OrderBloc();
  final rescheduleBloc = RescheduleBloc();
  final appointmentBloc = AppointmentBloc();

  RescheduleModel _reschedule;

  @override
  void initState() {
    bloc.dispatch(ResetStateEvent());
    bloc.dispatch(EventCallDayOff(companyId: widget.companyId));
    bloc.dispatch(
      EventCallStaffList(
        serviceId: this.widget.servicePackageId,
        branchId: this.widget.branchId,
        dateTime: DateTime.now(),
      ),
    );
    super.initState();
    calendarController = CalendarController();
    _reschedule = RescheduleModel();
  }

  int _idSelected = -1;

  String staffId;
  String staffName;
  String timeSelect;
  List<StaffModel> staffs;
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.whitetwo,
      // appBar: AppBar(
      //   title: Text(
      //     'Đặt lịch khám',
      //     style:TextStyle(
      //         fontFamily: 'Montserrat-M',fontSize: useMobileLayout ? 16 : 28),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Color(0xFFF47A4D),
      // ),
      appBar: const TopAppBar(),
      body: BlocProvider<OrderEvent, OrderState, OrderBloc>(
          bloc: bloc,
          builder: (state) {
            staffs = state.staffs;
            return
                // Stack(
                //   alignment: Alignment.bottomCenter,
                //   children: <Widget>[
                SingleChildScrollView(
                    child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomAppBar(
                    title: language.book,
                    titleSize: 18,
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(bottom: 0, top: 24),
                    child: Column(
                      children: [
                        Container(
                          //height: useMobileLayout ? 40 : 60,
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          child: Container(
                            padding: const EdgeInsets.only(left: 21),
                            child: Text(
                              language.selectDate,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: useMobileLayout ? 16 : 28,
                                  color: AppColor.darkPurple,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        BlocProvider<OrderEvent, OrderState, OrderBloc>(
                          bloc: bloc,
                          builder: (detailState) {
                            return CalendarScreen(
                              enabledDayPredicate: (DateTime date) {
                                return detailState.dayOff == null
                                    ? true
                                    : !detailState.dayOff.dayOffs.any(
                                        (element) =>
                                            element.day == date.day &&
                                            element.month == date.month &&
                                            element.year == date.year);
                              },
                              onChanage: (date) {
                                setState(() {
                                  dateTime = date;
                                  // bloc.dispatch((LoadDoctor(dateTime: dateTime)));
                                  if (widget.useStaff == true) {
                                    bloc.dispatch(EventCallStaffList(
                                        serviceId: this.widget.servicePackageId,
                                        branchId: this.widget.branchId,
                                        dateTime: date));
                                    if (widget.useBookingTime == true) {
                                      if (state.staffId != "") {
                                        _isVisibleContinueButton = false;
                                        bloc.dispatch(LoadTime(
                                            id: state.staffId, dateTime: date));
                                      }
                                    }
                                  }
                                  isSelected = false;
                                  bloc.dispatch(ResetStateEvent());
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25, bottom: 20),
                    height: useMobileLayout ? 40 : 60,
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Container(
                        padding: const EdgeInsets.only(left: 21),
                        child: Text(
                          widget.useStaff == true ? language.selectDoctor : "",
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: useMobileLayout ? 16 : 28,
                              color: AppColor.darkPurple,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  widget.useStaff == true
                      ? Container(
                          height: 230,
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          width: double.infinity,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.staffs?.length ?? 0,
                              itemBuilder: (context, index) {
                                var item = state.staffs[index];
                                return ChooseDoctorItem(
                                  useBookingTime: widget.useBookingTime,
                                  doctors: item,
                                  listStaff: state.staffs,
                                  useStaff: widget.useStaff == true,
                                  dateWorking:
                                      dateTime == null ? null : dateTime,
                                  onPress: () {
                                    setState(() {
                                      _isVisibleContinueButton = true;
                                      isSelected = !isSelected;
                                    });
                                    bloc.dispatch(ChooseDoctorEvent(
                                        staffId: item?.id ?? ''));
                                    staffName = item?.name ?? '';
                                    staffId = item?.id ?? '';
                                  },
                                  //isSelected: isSelected,
                                  colors: (_idSelected == index)
                                      ? Colors.grey
                                      : AppColor.orangeColor,
                                  onClick: () {
                                    isSelected = !isSelected;
                                    _idSelected = index;
                                    setState(() {
                                      staffName = item?.name ?? '';
                                      staffId = item?.id ?? '';
                                      //   print(staffId);
                                      //   timeSelect =
                                      //       state?.workingTimeSelected ?? '';
                                      //   _isVisibleContinueButton = true;
                                    });
                                  },
                                );
                              }))
                      : Container(),
                  (staffId != null)
                      ? Container(
                          padding: EdgeInsets.only(bottom: 15, left: 15),
                          child: Text(
                            widget.useStaff == true ? language.selectTime : "",
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: useMobileLayout ? 16 : 28,
                                color: AppColor.darkPurple,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(),
                  (staffId != null)
                      ? Container(
                          width: MediaQuery.of(context).size.height * 0.9,
                          padding: EdgeInsets.only(bottom: 70),
                          alignment: Alignment.center,
                          child: ChooseTime(
                            listTime: state?.workingTimes ?? [],
                            onClick: () {
                              setState(() {
                                // staffName = item?.name ?? '';
                                // staffId = item?.id ?? '';
                                // print(staffId);
                                timeSelect = state?.workingTimeSelected ?? '';
                                _isVisibleContinueButton = true;
                              });
                            },
                          ),
                        )
                      : Container()
                ],
              ),
            ));
            //   ],
            // );
          }),
      //

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: (widget.useStaff == true && !_isVisibleContinueButton)
            ? _isVisibleContinueButton
            : true,
        child: Container(
          padding: const EdgeInsets.only(left: 31, right: 31),
          child: BlocProvider<OrderEvent, OrderState, OrderBloc>(
              bloc: bloc,
              builder: (state) {
                return BlocProvider<RescheduleEvent, RescheduleState,
                    RescheduleBloc>(
                  bloc: rescheduleBloc,
                  // navigator: (resState) {
                  //   if (resState.isUpdate == true) {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => AppointmentScreen(
                  //           stateNumber: widget.stateNumber,
                  //         ),
                  //       ),
                  //     );
                  //   }
                  // },
                  builder: (resState) {
                    return CustomButton(
                      color: AppColor.purple,
                      onPressed: (dateTime == null || staffId == null)
                          ? () {
                              MsgDialog.showMsgDialog(
                                  context,
                                  'Không thể đặt lịch',
                                  'Vui lòng chọn bác sĩ và khung giờ hẹn');
                            }
                          : widget.isReschedule != true
                              ? () {
                                  if (widget?.contact == null)
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChooseFileScreen(
                                            gender: widget.gender,
                                            fromAge: widget.fromAge,
                                            toAge: widget.toAge,
                                            useBookingTime:
                                                widget.useBookingTime,
                                            timeSelect: timeSelect,
                                            staffId: widget.useStaff == true
                                                ? staffId
                                                : '',
                                            staffName: widget.useStaff == true
                                                ? staffName
                                                : this.widget.companyName,
                                            address: this.widget.address,
                                            servicePackageId:
                                                widget.servicePackageId,
                                            dateTime: widget.useStaff == true
                                                ? widget.useBookingTime == false
                                                    ? dateTime
                                                    : state
                                                        .workingTimeModel.from
                                                : dateTime,
                                            branchId: widget?.branchId),
                                      ),
                                    );
                                  else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateInforScreen(
                                          timeSelect: timeSelect,
                                          servicePackageId:
                                              widget.servicePackageId,
                                          staffName: widget.useStaff == true
                                              ? staffName
                                              : this.widget.companyName,
                                          useBookingTime: widget.useBookingTime,
                                          address: this.widget.address,
                                          dateTime: widget.useStaff == true
                                              ? widget.useBookingTime == false
                                                  ? dateTime
                                                  : state.workingTimeModel.from
                                              : dateTime,
                                          staffId: widget.useStaff == true
                                              ? staffId
                                              : null,
                                          patientId: widget?.contact?.id,
                                          isCreated: true,
                                          contact: widget?.contact,
                                          branchId: widget?.branchId,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              : () {
                                  _reschedule.appointmentTime =
                                      widget.useStaff == true
                                          ? widget.useBookingTime == false
                                              ? dateTime
                                              : state.workingTimeModel.from
                                          : dateTime;
                                  _reschedule.staffId =
                                      widget.useStaff == true ? staffId : null;
                                  rescheduleBloc
                                      .dispatch(RescheduleAppointmentEvent(
                                    appointmentId: widget.appointmentId,
                                    reschedule: _reschedule,
                                  ));

                                  appointmentBloc.dispatch(EventLoadAppointment(
                                      filterQuery:
                                          widget.appointmentFilterQuery,
                                      type: widget.stateNumber));
                                  // appointmentBloc.dispatch(
                                  //     LoadDetailAppointmentvent(
                                  //         id: this.widget.appointmentId));
                                  Navigator.of(context).maybePop();
                                },
                      radius: BorderRadius.circular(40),
                      text: widget.isReschedule != true
                          ? language.book
                          : language.changeAppointment,
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: useMobileLayout ? 16 : 28,
                          color: AppColor.white),
                      icon: 'assets/images/Calendar2.png',
                    );
                  },
                );
              }),
        ),
      ),
    );
  }

  List<CalendarModel> calendar;
}
