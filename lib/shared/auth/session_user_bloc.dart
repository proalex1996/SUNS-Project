import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_model.dart';

class UserState {
  UserModel user;
  UserState({this.user});
}

abstract class UserEvent {}

class GetUserEvent extends UserEvent {}

class UserBloc extends BlocBase<UserEvent, UserState> {
  static final UserBloc _instance = UserBloc._internal();
  UserBloc._internal();

  factory UserBloc() {
    return _instance;
  }
  @override
  void initState() {
    this.state = new UserState();
    super.initState();
  }

  @override
  Future<UserState> mapEventToState(UserEvent event) async {
    if (event is GetUserEvent) {
      await getUser();
    }
    return this.state;
  }

  Future getUser() async {
    final service = ServiceProxy().userService;
    this.state.user = await service.getUserInfo();
  }
}
