import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/user_report_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class UserSupportState {
  UserSupportModel userSupportModel;
  UserSupportState({this.userSupportModel});
}

abstract class UserSupportEvent {}

class EventLoadUserSupport extends UserSupportEvent {
  EventLoadUserSupport();
}

class UserSupportBloc extends BlocBase<UserSupportEvent, UserSupportState> {
  @override
  void initState() {
    this.state = new UserSupportState();
    super.initState();
  }

  @override
  Future<UserSupportState> mapEventToState(UserSupportEvent event) async {
    if (event is EventLoadUserSupport) {
      await _getUserSupport();
    }
    return this.state;
  }

  Future _getUserSupport() async {
    final serviceProxy = ServiceProxy().newCommonServiceProxy;
    var res = await serviceProxy.getUserSupport();
    this.state.userSupportModel = res;
  }
}
