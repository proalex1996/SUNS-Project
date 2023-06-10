import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/gender_model.dart';

class GenderState {
  Map<int, GenderModel> mapGenders;
  GenderState({this.mapGenders});
}

abstract class GenderEvent {}

class GetGenderEvent extends GenderEvent {}

class GenderBloc extends BlocBase<GenderEvent, GenderState> {
  @override
  void initState() {
    this.state = new GenderState();
    super.initState();
  }

  @override
  Future<GenderState> mapEventToState(GenderEvent event) async {
    if (event is GetGenderEvent) {
      await _initGender();
    }
    return this.state;
  }

  Future _initGender() async {
    final service = ServiceProxy();
    var genders = await service.commonService.getAllGender();
    this.state.mapGenders = genders.asMap();
  }
}
