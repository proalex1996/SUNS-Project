import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/common/dto/medical_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/equipment/dto/equipment_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class MedicalState {
  List<MedicalModel> medical;
  EquipmentModel equipment;
  bool hasLike;
  MedicalState({this.medical, this.equipment, this.hasLike});
}

abstract class MedicalEvent {}

class LoadMedicalEvent extends MedicalEvent {}

class EventLikeEquipment extends MedicalEvent {
  String id;
  EventLikeEquipment({this.id});
}

class EventUnlikeEquipment extends MedicalEvent {
  String id;
  EventUnlikeEquipment({this.id});
}

class EventShareEquipment extends MedicalEvent {
  String id;
  EventShareEquipment({this.id});
}

class EventDetailEquipment extends MedicalEvent {
  String id;
  EventDetailEquipment({this.id});
}

class MedicalBloc extends BlocBase<MedicalEvent, MedicalState> {
  @override
  void initState() {
    this.state = new MedicalState();
    super.initState();
  }

  @override
  Future<MedicalState> mapEventToState(MedicalEvent event) async {
    if (event is LoadMedicalEvent) {
      await _getMedical();
    } else if (event is EventDetailEquipment) {
      await _getDetailEquipment(event.id);
      await _getHasLikeEquipment(event.id);
    } else if (event is EventLikeEquipment) {
      await _likeEquipment(event.id);
    } else if (event is EventUnlikeEquipment) {
      await _unlikeEquipment(event.id);
    } else if (event is EventShareEquipment) {
      await _shareEquipment(event.id);
    }
    return this.state;
  }

  Future _getMedical() async {
    final service = ServiceProxy().managementCommonService;
    this.state.medical = await service.getMedical();
  }

  Future _getDetailEquipment(String id) async {
    final service = ServiceProxy().equipmentServiceProxy;
    this.state.equipment = await service.getDetailEquipment(id);
  }

  Future _getHasLikeEquipment(String id) async {
    final service = ServiceProxy().equipmentServiceProxy;
    this.state.hasLike = await service.hasLikeEquipment(id);
  }

  Future _likeEquipment(String id) async {
    final service = ServiceProxy().equipmentServiceProxy;
    await service.likeEquipment(id);
    this.state.hasLike = await service.hasLikeEquipment(id);
    this.state.equipment = await service.getDetailEquipment(id);
  }

  Future _unlikeEquipment(String id) async {
    final service = ServiceProxy().equipmentServiceProxy;
    await service.unlikeEquipment(id);
    this.state.hasLike = await service.hasLikeEquipment(id);
    this.state.equipment = await service.getDetailEquipment(id);
  }

  Future _shareEquipment(String id) async {
    final service = ServiceProxy().equipmentServiceProxy;
    await service.shareEquipment(id);
    this.state.equipment = await service.getDetailEquipment(id);
  }
}
