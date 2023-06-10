import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/input_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/create_contact_model.dart';

class CreateFileState {
  ContactModel contact;
  int contactId;
  List<AppointmentNewsModel> appointmentNews;
  bool checkState;
  CreateFileState({this.contact, this.contactId, this.checkState = false});
}

abstract class CreateFileEvent {}

class EventCreateFile extends CreateFileEvent {
  CreateContactModel createContact;
  DateTime dateTime;
  ContactModel contact;
  EventCreateFile({
    this.contact,
    this.createContact,
    this.dateTime,
  });
}

class EventResetState extends CreateFileEvent {}

class CreateFileBloc extends BlocBase<CreateFileEvent, CreateFileState> {
  @override
  void initState() {
    this.state = new CreateFileState();
    this.state.checkState = false;
    super.initState();
  }

  @override
  Future<CreateFileState> mapEventToState(CreateFileEvent event) async {
    if (event is EventCreateFile) {
      this.state.checkState = await _createContact(
        event.dateTime,
        event.contact,
      );
    } else if (event is EventResetState) {
      this.state.checkState = false;
    }
    return this.state;
  }

  Future _createContact(DateTime dateTime, ContactModel contact) async {
    final service = ServiceProxy().userService;
    var createContact = CreateContactModel.fromContactModel(contact);
    var res = await service.createContact(createContact);
    if (res != null) {
      this.state.contactId = res;
      return true;
    }
  }

  // Future _loadAppointmentNews() async {
  //   final service = ServiceProxy().appointmentServiceProxy;
  //   var res = await service.getAppointmentNews();
  //   this.state.appointmentNews = res?.data;
  // }
}
