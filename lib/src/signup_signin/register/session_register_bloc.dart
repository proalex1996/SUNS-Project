import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/check_exist_phone_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/register_model.dart';

class RegisterState {
  RegisterModel register;
  bool isRegister;
  RegisterState({this.register, this.isRegister = false});
}

abstract class RegisterEvent {}

class EventRegister extends RegisterEvent {
  RegisterModel register;
  EventRegister({this.register});
}

class EventResetState extends RegisterEvent {}

class EventCheckExistPhone extends RegisterEvent {
  CheckExistPhoneModel phoneNumber;
  EventCheckExistPhone({this.phoneNumber});
}

class RegisterBloc extends BlocBase<RegisterEvent, RegisterState> {
  @override
  void initState() {
    this.state = RegisterState();
    this.state.isRegister = false;
    super.initState();
  }

  @override
  Future<RegisterState> mapEventToState(RegisterEvent event) async {
    if (event is EventRegister) {
      this.state.isRegister = await _register(event.register);
    } else if (event is EventCheckExistPhone) {
      await _checkExistPhone(event.phoneNumber);
    } else if (event is EventResetState) {
      this.state.isRegister = false;
    }
    return this.state;
  }

  Future _register(RegisterModel registerModel) async {
    final service = ServiceProxy();
    // registerModel.phoneNumber = _phoneNumberController.text;
    var res = await service.userService.register(registerModel);
    if (res != null) {
      return true;
    }
    return false;
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (ctx) => BottomBar()));
  }

  Future _checkExistPhone(CheckExistPhoneModel phoneNumber) async {
    final service = ServiceProxy().userService;
    await service.checkExistPhone(phoneNumber);
  }
}
