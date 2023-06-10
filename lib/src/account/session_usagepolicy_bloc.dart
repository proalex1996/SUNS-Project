import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class PolicyState {
  String data;
  PolicyState({this.data});
}

abstract class PolicyEvent {}

class EventGetData extends PolicyEvent {}

class PolicyBloc extends BlocBase<PolicyEvent, PolicyState> {
  // static final PolicyBloc _singleton = PolicyBloc._internal();

  // factory PolicyBloc() {
  //   return _singleton;
  // }

  // PolicyBloc._internal();
  @override
  void initState() {
    this.state = new PolicyState();
    super.initState();
  }

  @override
  Future<PolicyState> mapEventToState(PolicyEvent event) async {
    if (event is EventGetData) {
      await _getUsagePolicy();
    }
    return this.state;
  }

  Future _getUsagePolicy() async {
    final service = ServiceProxy().userService;
    this.state.data = await service.getUsagePolicy();
    print(this.state.data);
  }
}
