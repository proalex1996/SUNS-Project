import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/create_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/appointment_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class CreateAppointmentState {
  CreateAppointmentModel createAppointment;
  bool checkPayment;
  CreateAppointmentState({this.createAppointment, this.checkPayment = false});
}

abstract class CreateAppointmentEvent {}

class EventCheckPayment extends CreateAppointmentEvent {}

class CreateEvent extends CreateAppointmentEvent {
  CreateAppointmentModel createAppointment;
  String userName, orderNo;
  double price;
  String doctorId;
  InputAppointmentModel input;
  String companyId;
  CreateEvent(
      {this.createAppointment,
      this.price,
      this.userName,
      this.orderNo,
      this.doctorId,
      this.input,
      this.companyId});
}

class CreateAppointmentBloc
    extends BlocBase<CreateAppointmentEvent, CreateAppointmentState> {
  CreateAppointmentModel create = new CreateAppointmentModel();
  @override
  void initState() {
    this.state = new CreateAppointmentState();
    this.state.checkPayment = false;
    super.initState();
  }

  @override
  Future<CreateAppointmentState> mapEventToState(
      CreateAppointmentEvent event) async {
    if (event is CreateEvent) {
      await _createAppointment(
          event.userName, event.price, event.orderNo, event.doctorId);
      // await _inputAppointment(event.input, event.companyId);
      this.state.checkPayment = true;
    }
    return this.state;
  }

  // Future _inputAppointment(
  //     InputAppointmentModel input, String companyId) async {
  //   final service = ServiceProxy().doctorServiceProxy;
  //   // _input = input;
  //   _input.patientId = 1;
  //   _input.prescriptionFile = "";
  //   _input.appointmentTime = "2021-01-13T09:31:13.836Z";
  //   _input.staffId = null;
  //   _input.servicePackageId = "9e11db8a-697a-4e29-9681-81b25055099f";
  //   _input.companyId = companyId;
  //   await service.createAppointment(_input, companyId);
  // }

  Future _createAppointment(
      String userName, double price, String orderNo, String doctorId) async {
    create.clinicId = 1;
    create.doctorId = 1;
    create.transactionId = "1";
    create.userName = userName;
    create.price = price;
    create.orderNo = orderNo;
    create.lang = "vi";
    create.paymentType = "2";
    final service = ServiceProxy().hospitalService;
    this.state.createAppointment = await service.createAppointment(create);
    // this.state.checkPayment = true;
  }
}
