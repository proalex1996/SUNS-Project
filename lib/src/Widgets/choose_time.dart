import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/staff_model.dart';
import 'package:suns_med/src/order/buttontime.dart';
import 'package:suns_med/src/order/session_order_bloc.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/working_time_model.dart';

import 'package:suns_med/src/doctor/detail_doctor.dart';
import 'package:suns_med/src/Widgets/doctor_widget.dart';
import 'package:suns_med/src/order/order_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/staff/dto/staff_detail_model.dart';

class ChooseTime extends StatefulWidget {
  // final StaffModel doctors;
  final VoidCallback onClick;
  final bool useStaff;
  final List<WorkingTimeModel> listTime;
  // final Function onPress;
  // final bool useBookingTime;
  // final Color colors;
  // final Function onChange;
  // final DateTime dateWorking;
  // final List<StaffModel> listStaff;

  // final String from;
  //final bool isSelected;
  const ChooseTime({
    Key key,
    // this.doctors,
    // this.listStaff,
    //this.isSelected,
    @required this.onClick,
    this.listTime,
    // this.useBookingTime,
    // this.colors,
    this.useStaff,
    // this.dateWorking,
    // this.from,
    // this.onChange,
    // this.onPress,
  }) : super(key: key);

  @override
  _ChooseTimeState createState() => _ChooseTimeState();
}

class _ChooseTimeState extends State<ChooseTime> {
  //bool isSelected = false;
  final bloc = OrderBloc();

  @override
  void initState() {
    //bloc.dispatch(ResetStateEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var language = AppLocalizations.of(context);
    // var shortestSide = MediaQuery.of(context).size.shortestSide;
    // var useMobileLayout = shortestSide < 600;
    // return BlocProvider<OrderEvent, OrderState, OrderBloc>(
    //     bloc: bloc,
    //     builder: (state) {
    //       if (state.workingTimes.isEmpty)
    //         return Container();
    //       else
    // final isSelect = widget.useBookingTime == true
    //     ? false
    //     : state.staffId != null &&
    //         state.staffId.isNotEmpty &&
    //         state.staffId == widget.doctors.id;
    // return
    // Stack(
    //   children: <Widget>[
    //   Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: <Widget>[
    // widget.isSelected
    //     ?

    //     : SizedBox(),
    // widget.isSelected
    //     ?
    // BlocProvider<OrderEvent, OrderState, OrderBloc>(
    //     bloc: bloc,
    //     builder: (state) {
    return Wrap(
      children: List.generate(widget?.listTime?.length ?? 0, (index) {
        return ButtonTime(
          onClick: () {
            this.widget.onClick();
          },
          workingTimeModel: widget?.listTime[index],
          from: widget?.listTime[index].from,
          //.toIso8601String(),
          hour: widget?.listTime[index].hour,
          isActive: widget?.listTime[index].active,
        );
      }),
    );
    // });
    //     : SizedBox(),
    // widget.isSelected
    // ?
    //     SizedBox(
    //       height: 70,
    //     )
    //     // : SizedBox()
    //   ],
    //   //   ),
    //   // ],
    // );
    // });
  }

  // void showMsgDialog(BuildContext context, StaffDetailModel staff) {
  //   showDialog(
  //       context: context,
  //       child: Dialog(
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //         child: _buildDialog(context, staff),
  //       ));
  // }

  // Future<void> loadDoctor(String doctorId) async {
  //   bloc.dispatch(EventLoadDetailDoctor(doctorId: widget?.doctors?.id));
  // }

  // _buildDialog(context, StaffDetailModel staff) => DetailDoctorWidget(
  //     doctor: staff,
  //     onTap: () {
  //       Navigator.pop(context);
  //     });
}
