import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/change_password_model.dart';

class ChangePasswordState {
  bool isChanged;
  ChangePasswordState({this.isChanged = false});
}

abstract class ChangePasswordEvent {}

class ChangeEvent extends ChangePasswordEvent {
  ChangePasswordModel changePasswordModel;
  ChangeEvent({this.changePasswordModel});
}

class ChangePasswordBloc
    extends BlocBase<ChangePasswordEvent, ChangePasswordState> {
  @override
  void initState() {
    this.state = ChangePasswordState();
    super.initState();
  }

  @override
  Future<ChangePasswordState> mapEventToState(ChangePasswordEvent event) async {
    if (event is ChangeEvent) {
      await _changePassword(event.changePasswordModel);
    }
    return this.state;
  }

  Future _changePassword(ChangePasswordModel changePasswordModel) async {
    final service = ServiceProxy();
    await service.userService.changePassword(changePasswordModel);
  }
}
