import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/common/dto/banner_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/common/dto/department_special_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/hospital_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/banner_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/department_special/dto/department_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class DepartmentState {
  List<DepartmentSpecialModel> department;
  List<BannerModel> banner;
  List<HospitalModel> doctorByDepartment;
  // APi moi
  List<DepartmentModel> departmentNew;
  List<NewBannerModel> bannerNew;
  DepartmentState({this.department, this.banner, this.doctorByDepartment});
}

abstract class DepartmentEvent {}

class LoadDepartmentEvent extends DepartmentEvent {}

class LoadDoctorByDepartment extends DepartmentEvent {
  final String department;
  LoadDoctorByDepartment({this.department});
}

class DepartmentBloc extends BlocBase<DepartmentEvent, DepartmentState> {
  static final DepartmentBloc _singleton = DepartmentBloc._internal();

  factory DepartmentBloc() {
    return _singleton;
  }

  DepartmentBloc._internal();
  @override
  void initState() {
    this.state = new DepartmentState();
    super.initState();
  }

  @override
  Future<DepartmentState> mapEventToState(DepartmentEvent event) async {
    if (event is LoadDepartmentEvent) {
      // await _loadDepartment();
      // var department = _getDepartment();
      // var banner = _getBanner();
      // await Future.wait([department, banner]);
      await _getBanner();
    } else if (event is LoadDoctorByDepartment) {
      await _loadDoctorByDepartment(event.department);
    }

    return this.state;
  }

  Future _loadDoctorByDepartment(String department) async {
    final service = ServiceProxy().managementCommonService;
    this.state.doctorByDepartment =
        await service.doctorByDepartment(department);
  }

  // Future _loadDepartment() async {
  //   final service = ServiceProxy().managementCommonService;
  //   this.state.banner = await service.getAllBanner();
  //   this.state.department = await service.getAllDepartment();
  // }

  Future _getBanner() async {
    final service = ServiceProxy().newCommonServiceProxy;
    this.state.bannerNew = await service.getAllBanner();
  }

  // Future _getDepartment() async {
  //   final service = ServiceProxy().departmentServiceProxy;
  //   this.state.departmentNew = await service.getAllDepartment();
  // }
}
