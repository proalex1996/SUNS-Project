import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';

class UpdateContactState {
  bool isUpdated;
  UpdateContactState({this.isUpdated = false});
}

abstract class UpdateContactEvent {}

class UpdateEvent extends UpdateContactEvent {
  int contactId;
  ContactModel updateContact;
  UpdateEvent({this.contactId, this.updateContact});
}

class UpdateContactBloc
    extends BlocBase<UpdateContactEvent, UpdateContactState> {
  ContactModel updateContact = ContactModel();
  @override
  void initState() {
    this.state = UpdateContactState();
    super.initState();
  }

  @override
  Future<UpdateContactState> mapEventToState(UpdateContactEvent event) async {
    if (event is UpdateEvent) {
      this.state.isUpdated =
          await _updateContact(event.contactId, event.updateContact);
    }
    return this.state;
  }

  Future _updateContact(int contactId, ContactModel updateContact) async {
    final service = ServiceProxy();
    var res = await service.userService.updateContact(contactId, updateContact);
    if (res != null) return true;
  }
}
