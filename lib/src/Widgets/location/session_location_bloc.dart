import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/doctor_hospital_clinic_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/equipment/dto/equipment_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';

class LocationState {
  List<ProvinceModel> listProvince;
  List<ListDHCModel> listSearch;
  List<ListDHCModel> listCompany;
  ProvinceModel provinceSelected;
// state new Model
  List<ListDHCModel> doctorNew;
  List<ListDHCModel> hospitalNew;
  List<ListDHCModel> clinicNew;
  List<EquipmentModel> listEquipment;

  LocationState(
      {this.listProvince,
      this.provinceSelected,
      this.listSearch,
      this.clinicNew,
      this.doctorNew,
      this.listCompany,
      this.hospitalNew,
      this.listEquipment});
}

abstract class LocationEvent {}

class InitLocationEvent extends LocationEvent {
  String locationName;
  InitLocationEvent({this.locationName});
}

class SelectLocationEvent extends LocationEvent {
  ProvinceModel province;
  SelectLocationEvent({this.province});
}

class SelectLocationOfDoctorEvent extends LocationEvent {
  ProvinceModel province;
  int type;
  SelectLocationOfDoctorEvent({this.province, this.type});
}

class SelectLocationOfHospitalEvent extends LocationEvent {
  ProvinceModel province;
  int type;
  SelectLocationOfHospitalEvent({this.province, this.type});
}

class SelectLocationOfClinicEvent extends LocationEvent {
  ProvinceModel province;
  int type;
  SelectLocationOfClinicEvent({this.province, this.type});
}

class SelectLocationOfEquipmentEvent extends LocationEvent {
  ProvinceModel province;
  int type;
  SelectLocationOfEquipmentEvent({this.province, this.type});
}

class EventSearch extends LocationEvent {
  String keyword;
  EventSearch({this.keyword});
}

class EventSearchCompay extends LocationEvent {
  String keyword, companyType;
  EventSearchCompay({this.keyword, this.companyType});
}

class EventResetKeyword extends LocationEvent {
  String keyword, companyType;
  EventResetKeyword({this.keyword, this.companyType});
}

class EventLoadCompanyBydepartmentId extends LocationEvent {
  int departmentId;
  EventLoadCompanyBydepartmentId({this.departmentId});
}

class EventSearchDepartment extends LocationEvent {
  String keyword;
  int departmentId;
  EventSearchDepartment({this.keyword, this.departmentId});
}

class ListCompanyEvent extends LocationEvent {}

class LocationBloc extends BlocBase<LocationEvent, LocationState> {
  static final LocationBloc _singleton = LocationBloc._internal();

  factory LocationBloc() {
    return _singleton;
  }

  LocationBloc._internal();

  @override
  void initState() {
    this.state = new LocationState();
    super.initState();
  }

  @override
  Future<LocationState> mapEventToState(LocationEvent event) async {
    if (event is SelectLocationEvent) {
      this.state.provinceSelected = event.province;
      await _getListDoctor(this.state.provinceSelected.id);
      await _getListHospital(this.state.provinceSelected.id);
      await _getListClinic(this.state.provinceSelected.id);
      // await _loadItemPopular(this.state.provinceSelected.id);
    }
    if (event is SelectLocationOfDoctorEvent) {
      this.state.provinceSelected = event.province;
      await _getListDoctor(this.state.provinceSelected.id);
    }
    if (event is SelectLocationOfHospitalEvent) {
      this.state.provinceSelected = event.province;
      await _getListHospital(this.state.provinceSelected.id);
    }
    if (event is SelectLocationOfClinicEvent) {
      this.state.provinceSelected = event.province;
      await _getListClinic(this.state.provinceSelected.id);
    } else if (event is SelectLocationOfEquipmentEvent) {
      await _getListEquipment(this.state.provinceSelected.id);
    } else if (event is EventSearch) {
      await _getListSearchCompany(
          this.state.provinceSelected.id, event.keyword);
    } else if (event is ListCompanyEvent) {
      await _getAllCompany(this.state.provinceSelected.id);
    } else if (event is InitLocationEvent) {
      await _initProvince(event.locationName);
      // await _getListDoctor(this.state.provinceSelected.id);
      // await _getListHospital(this.state.provinceSelected.id);
      // await _getListClinic(this.state.provinceSelected.id);
    } else if (event is EventLoadCompanyBydepartmentId) {
      await _getCompanyByDepartment(
          this.state.provinceSelected.id, event.departmentId);
    } else if (event is EventSearchCompay) {
      await _getSearchCompanyByCompany(
          this.state.provinceSelected.id, event.keyword, event.companyType);
    } else if (event is EventResetKeyword) {
      this.state.listSearch = null;
    } else if (event is EventSearchDepartment) {
      await _getSearchCompanyByDepartment(
          this.state.provinceSelected.id, event.keyword, event.departmentId);
    }

    return this.state;
  }

  Future _initProvince(String locationName) async {
    final service = ServiceProxy().commonService;
    this.state.listProvince = await service.getAllCities();
    var hasLocationName = locationName != null && locationName.isNotEmpty;
    this.state.provinceSelected = this.state.listProvince.firstWhere(
        (x) =>
            hasLocationName &&
                locationName.toLowerCase().contains(x.name?.toLowerCase()) ||
            !hasLocationName && x.id == "701",
        orElse: () => null);
  }
  // API moi

  Future _getListDoctor(String provinceId) async {
    final service = ServiceProxy().provinceServiceProxy;
    var res = await service.getListDHC(provinceId, "Doctor");
    this.state.doctorNew = res?.data;
  }

  Future _getListHospital(String provinceId) async {
    final service = ServiceProxy().provinceServiceProxy;
    var res = await service.getListDHC(provinceId, "Hospital");
    this.state.hospitalNew = res?.data;
  }

  Future _getListClinic(String provinceId) async {
    final service = ServiceProxy().provinceServiceProxy;
    var res = await service.getListDHC(provinceId, "Clinic");
    this.state.clinicNew = res?.data;
  }

  Future _getListEquipment(String provinceId) async {
    final service = ServiceProxy().provinceServiceProxy;
    var res = await service.getListEquipment(provinceId);
    this.state.listEquipment = res?.data;
  }

  Future _getListSearchCompany(String id, String keyword) async {
    final service = ServiceProxy().provinceServiceProxy;
    var res = await service.searchCompany(id, keyword);
    this.state.listSearch = res?.data;
  }

  Future _getSearchCompanyByCompany(
      String id, String keyword, String companyType) async {
    final service = ServiceProxy().provinceServiceProxy;
    var res =
        await service.getListSearchCompanyByCompany(id, companyType, keyword);
    this.state.listSearch = res?.data;
  }

  Future _getAllCompany(String id) async {
    final service = ServiceProxy().provinceServiceProxy;
    var res = await service.getAllCompany(id);
    this.state.listCompany = res?.data;
  }

  Future _getCompanyByDepartment(String provinceId, int departmentId) async {
    final service = ServiceProxy().provinceServiceProxy;
    var res = await service.getCompanyByDepartment(provinceId, departmentId);
    this.state.listCompany = res?.data;
  }

  Future _getSearchCompanyByDepartment(
      String provinceId, String keyword, int departmentSpecialId) async {
    final service = ServiceProxy().provinceServiceProxy;
    var res = await service.getListSearchCompanyByDepartment(
        provinceId, departmentSpecialId, keyword);
    this.state.listSearch = res?.data;
  }
}
