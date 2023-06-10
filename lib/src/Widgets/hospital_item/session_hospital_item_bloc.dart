import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/hospital_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class HospitalItemState {
  List<HospitalModel> item;
  HospitalItemState({this.item});
}

abstract class HospitalItemEvent {}

class LoadItemEvent extends HospitalItemEvent {
  String id;
  int type;
  LoadItemEvent({this.id, this.type});
}

class HospitalItemBloc extends BlocBase<HospitalItemEvent, HospitalItemState> {
  static final HospitalItemBloc _instance = HospitalItemBloc._internal();
  HospitalItemBloc._internal();

  factory HospitalItemBloc() {
    return _instance;
  }

  @override
  void initState() {
    this.state = new HospitalItemState();
    super.initState();
  }

  @override
  Future<HospitalItemState> mapEventToState(HospitalItemEvent event) async {
    if (event is LoadItemEvent) {
      await _loadItem(event.id, event.type);
    }

    return this.state;
  }

  Future _loadItem(String id, int type) async {
    final service = ServiceProxy().hospitalService;
    this.state.item = await service.getHospital(id, type);
  }
}
