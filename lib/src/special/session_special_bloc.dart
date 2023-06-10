import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/common/dto/department_special_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class DepartmentSpecialState {
  List<DepartmentSpecialModel> departmentDepartment;
  DepartmentSpecialState({this.departmentDepartment});
}

abstract class DepartmentSpecialEvent {}

class LoadDepartmentSpecialEvent extends DepartmentSpecialEvent {}

class DepartmentSpecialBloc
    extends BlocBase<DepartmentSpecialEvent, DepartmentSpecialState> {
  @override
  void initState() {
    this.state = new DepartmentSpecialState();
    super.initState();
  }

  @override
  Future<DepartmentSpecialState> mapEventToState(
      DepartmentSpecialEvent event) async {
    if (event is LoadDepartmentSpecialEvent) {
      await _getDepartmentSpecial();
    }
    return this.state;
  }

  Future _getDepartmentSpecial() async {
    final service = ServiceProxy().managementCommonService;
    this.state.departmentDepartment = await service.getAllDepartment();
  }
}
