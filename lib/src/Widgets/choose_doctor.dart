import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/staff_model.dart';
import 'package:suns_med/src/order/buttontime.dart';
import 'package:suns_med/src/order/session_order_bloc.dart';
import 'package:suns_med/src/doctor/detail_doctor.dart';
import 'package:suns_med/src/Widgets/doctor_widget.dart';
import 'package:suns_med/src/order/order_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/staff/dto/staff_detail_model.dart';

class ChooseDoctorItem extends StatefulWidget {
  final StaffModel doctors;
  final VoidCallback onClick;
  final bool useStaff;
  final Function onPress;
  final bool useBookingTime;
  final Color colors;
  final Function onChange;
  final DateTime dateWorking;
  final List<StaffModel> listStaff;

  final String from;
  //final bool isSelected;
  const ChooseDoctorItem({
    Key key,
    this.doctors,
    this.listStaff,
    //this.isSelected=false,
    @required this.onClick,
    this.useBookingTime,
    this.colors,
    this.useStaff,
    this.dateWorking,
    this.from,
    this.onChange,
    this.onPress,
  }) : super(key: key);

  @override
  _ChooseDoctorItemState createState() => _ChooseDoctorItemState();
}

class _ChooseDoctorItemState extends State<ChooseDoctorItem> {
  //bool isSelected = false;
  final bloc = OrderBloc();
  @override
  void initState() {
    bloc.dispatch(ResetStateEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return BlocProvider<OrderEvent, OrderState, OrderBloc>(
        bloc: bloc,
        builder: (state) {
          final isSelect = widget.useBookingTime == true
              ? false
              : state.staffId != null &&
                  state.staffId.isNotEmpty &&
                  state.staffId == widget.doctors.id;
          return
              // Stack(
              //   children: <Widget>[
              Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //await loadDoctor(widget?.doctors?.id);
                  //if (state?.staff != null)
                  showMsgDialog(context, widget?.doctors?.id);
                },
                child: Container(
                  //height: 300,
                  child: Row(
                    children: <Widget>[
                      DoctorWidget(
                        avatar: widget?.doctors?.image,
                        color: widget?.colors,
                        name: Text("${widget?.doctors?.name}",
                            style: isSelect
                                ? TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.darkPurple)
                                : TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                        onTap: widget.useBookingTime == false
                            ? widget.onPress
                            : () {
                                if (state.workingTimes != null) {
                                  if (state.workingTimes.length == 0) {
                                    Flushbar(
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                      title: language.notification,
                                      message: language.timeUp,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else {
                                    setState(() {
                                      state.staffId = widget.doctors.id;
                                      widget?.onClick();
                                      //isSelected = !isSelected;
                                    });
                                    bloc.dispatch(LoadTime(
                                        id: widget.doctors.id,
                                        dateTime: widget.dateWorking ??
                                            DateTime.now()));
                                  }
                                } else {
                                  setState(() {
                                    state.staffId = widget.doctors.id;
                                    widget?.onClick();

                                    // isSelected = !isSelected;
                                  });
                                  bloc.dispatch(LoadTime(
                                      id: widget.doctors.id,
                                      dateTime: widget.dateWorking ??
                                          DateTime.now()));
                                }
                              },
                      ),

                      // widget.doctors.image == null
                      //     ? Image.asset(
                      //         "assets/images/avatar2.png",
                      //         width: useMobileLayout ? 45 : 70,
                      //         height: useMobileLayout ? 45 : 70,
                      //       )
                      //     : Image.network(
                      //         widget.listStaff.isEmpty
                      //             ? ""
                      //             : widget.doctors.image,
                      //         width: useMobileLayout ? 45 : 70,
                      //         height: useMobileLayout ? 45 : 70,
                      //       ),
                      // Text(
                      //   widget.listStaff.isEmpty
                      //       ? "Không có bác sĩ làm việc vào ngày này"
                      //       : widget.doctors.name,
                      //   style:TextStyle(
                      //                fontFamily: 'Montserrat-M',
                      //       fontSize: useMobileLayout ? 16 : 28,
                      //       fontWeight: isSelect
                      //           ? FontWeight.bold
                      //           : FontWeight.normal,
                      //       color: isSelect
                      //           ? AppColor.deepBlue
                      //           : Colors.black),
                      // )
                    ],
                  ),
                ),
              ),
            ],
            //   ),
            // ],
          );
        });
  }

  void showMsgDialog(BuildContext context, String doctorId) {
    showDialog(
        context: context,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: _buildDialog(context, doctorId),
        ));
  }

  // Future<void> loadDoctor(String doctorId) async {
  //   bloc.dispatch(EventLoadDetailDoctor(doctorId: widget?.doctors?.id));
  // }

  _buildDialog(context, String doctorId) => DetailDoctorWidget(
      doctorId: doctorId,
      onTap: () {
        Navigator.pop(context);
      });
}
