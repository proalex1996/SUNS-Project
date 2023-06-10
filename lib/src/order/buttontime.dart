import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/working_time_model.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';
import 'package:suns_med/src/order/session_order_bloc.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class ButtonTime extends StatefulWidget {
  final String hour;
  final bool isActive;
  final DateTime from;
  final WorkingTimeModel workingTimeModel;
  final VoidCallback onClick;
  const ButtonTime(
      {Key key,
      this.isActive,
      this.hour,
      @required this.onClick,
      this.from,
      this.workingTimeModel})
      : super(key: key);

  @override
  _ButtonTimeState createState() => _ButtonTimeState();
}

class _ButtonTimeState extends State<ButtonTime> {
  String idTime = "";
  final bloc = OrderBloc();
  final appointmentBloc = AppointmentBloc();
  bool displaySelectedColor = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderEvent, OrderState, OrderBloc>(
        bloc: bloc,
        builder: (state) {
          final isSelected = state.workingTimeSelected != null &&
              state.workingTimeSelected.isNotEmpty &&
              state.workingTimeSelected == widget.hour;
          displaySelectedColor = isSelected ||
              appointmentBloc.state?.detailAppointment?.appointmentTime ==
                  widget.workingTimeModel?.from;

          return Container(
            margin: EdgeInsets.all(5),
            padding: const EdgeInsets.only(left: 3, right: 3),
            height: 34,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
                color: widget.isActive != true
                    ? Colors.white
                    : displaySelectedColor
                        ? AppColor.orangeColor
                        : Colors.white,
                border: Border.all(
                  color:
                      displaySelectedColor ? Colors.white : AppColor.lightGray,
                ),
                borderRadius: BorderRadius.circular(6)),
            child: FlatButton(
              onPressed: () {
                if (widget.isActive == true && isSelected != true) {
                  this.widget.onClick();
                  bloc.dispatch(ChooseTimeEvent(
                      workingTimeSelected: widget.hour,
                      workingTimeModel: widget.workingTimeModel));
                }
              },
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.from.hour.toString() + ':00',
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    color: widget.isActive != true
                        ? Colors.grey[600]
                        : displaySelectedColor
                            ? Colors.white
                            : AppColor.veryLightPinkTwo,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        });
  }
}
