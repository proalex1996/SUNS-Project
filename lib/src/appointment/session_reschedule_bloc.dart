import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/reschedule_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';

class RescheduleState {
  bool isUpdate;
  RescheduleState({this.isUpdate});
}

abstract class RescheduleEvent {}

class RescheduleAppointmentEvent extends RescheduleEvent {
  String appointmentId;
  RescheduleModel reschedule;
  RescheduleAppointmentEvent({this.appointmentId, this.reschedule});
}

class RescheduleBloc extends BlocBase<RescheduleEvent, RescheduleState> {
  @override
  void initState() {
    this.state = new RescheduleState();
    this.state.isUpdate = false;
    super.initState();
  }

  @override
  Future<RescheduleState> mapEventToState(RescheduleEvent event) async {
    if (event is RescheduleAppointmentEvent) {
      await _rescheduleAppointment(event.appointmentId, event.reschedule);
      await AppointmentBloc().loadDetailAppointment(event.appointmentId); //Todo Refactor
    }
    return this.state;
  }

  Future _rescheduleAppointment(
      String appointmentId, RescheduleModel reschedule) async {
    final serviceProxy = ServiceProxy();
    this.state.isUpdate = await serviceProxy.appointmentServiceProxy
        .rescheduleAppoinment(appointmentId, reschedule);
  }

  
}
