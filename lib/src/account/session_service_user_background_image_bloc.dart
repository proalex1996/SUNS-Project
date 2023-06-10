import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class UserBackgroundState {
  String urlBackground;
  UserBackgroundState({this.urlBackground});
}

abstract class UserBackgroundEvent {}

class EventLoadBackground extends UserBackgroundEvent {
  EventLoadBackground();
}

class UserBackgroundBloc
    extends BlocBase<UserBackgroundEvent, UserBackgroundState> {
  @override
  void initState() {
    this.state = new UserBackgroundState();
    super.initState();
  }

  @override
  Future<UserBackgroundState> mapEventToState(UserBackgroundEvent event) async {
    if (event is EventLoadBackground) {
      await _getUserBackground();
    }
    return this.state;
  }

  Future _getUserBackground() async {
    final serviceProxy = ServiceProxy().newCommonServiceProxy;
    var res = await serviceProxy.getBackground();
    this.state.urlBackground = res;
  }
}
