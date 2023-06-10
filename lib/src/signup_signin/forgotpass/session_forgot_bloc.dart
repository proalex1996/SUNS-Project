import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/forgot_password_model.dart';

class ForgotState {
  bool isUpdated;
  ForgotState({this.isUpdated = false});
}

abstract class ForgotEvent {}

class EventRePassword extends ForgotEvent {
  ForgotPasswordModel forgotPassword;
  EventRePassword({this.forgotPassword});
}

class ForgotBloc extends BlocBase<ForgotEvent, ForgotState> {
  @override
  void initState() {
    this.state = new ForgotState();
    this.state.isUpdated = false;
    super.initState();
  }

  @override
  Future<ForgotState> mapEventToState(ForgotEvent event) async {
    if (event is EventRePassword) {
      await _inputNewPassword(event.forgotPassword);
    }
    return this.state;
  }

  Future _inputNewPassword(ForgotPasswordModel _forgotPasswordModel) async {
    final service = ServiceProxy().userService;
    this.state.isUpdated = false;
    await service.forgotPass(_forgotPasswordModel);
    this.state.isUpdated = true;
  }
}
