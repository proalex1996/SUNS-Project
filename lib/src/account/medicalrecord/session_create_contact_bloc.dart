import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/create_contact_model.dart';

class CreateContactState {
  bool isCreated;
  CreateContactState({this.isCreated = false});
}

abstract class CreateContactEvent {}

class CreateEvent extends CreateContactEvent {
  CreateContactModel create;
  CreateEvent({this.create});
}

class CreateContactBloc
    extends BlocBase<CreateContactEvent, CreateContactState> {
  @override
  void initState() {
    this.state = CreateContactState();
    super.initState();
  }

  @override
  Future<CreateContactState> mapEventToState(CreateContactEvent event) async {
    if (event is CreateEvent) {
      this.state.isCreated = await _createContact(event.create);
    }
    return this.state;
  }

  Future _createContact(CreateContactModel createContact) async {
    final service = ServiceProxy();
    var a = await service.userService.createContact(createContact);
    if (a != null) return true;
  }
}
