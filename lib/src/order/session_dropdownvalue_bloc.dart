import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/gender_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';

class DropdownValueState {
  List<RelationshipModel> relationShip;
  List<GenderModel> gender;
  DropdownValueState({this.relationShip, this.gender});
}

abstract class DropdownValueEvent {}

class LoadRelationShipEvent extends DropdownValueEvent {}

class DropdownValueBloc
    extends BlocBase<DropdownValueEvent, DropdownValueState> {
  @override
  void initState() {
    this.state = new DropdownValueState();
    super.initState();
  }

  @override
  Future<DropdownValueState> mapEventToState(DropdownValueEvent event) async {
    if (event is LoadRelationShipEvent) {
      await _getRelationShip();
    }
    return this.state;
  }

  Future _getRelationShip() async {
    final service = ServiceProxy().commonService;
    this.state.relationShip = await service.getAllRelationship();
    this.state.gender = await service.getAllGender();
  }
}
