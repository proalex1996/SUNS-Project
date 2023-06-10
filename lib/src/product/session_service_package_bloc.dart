import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/examination_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/service_package_company_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/dto/detail_service_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/clinic/dto/clinic_branch_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/dto/branch_model.dart';

class ServicePackageState {
  PagingResult<ServicePackageOfCompanyModel> servicePackagePaging;
  PagingResult<ClinicBranchModel> clinicBranch;
  DetailServiceModel detailService;
  List<ExaminationModel> medicalTest = [];
  List<ExaminationModel> physicalExam = [];
  List<ExaminationModel> otherExam = [];
  List<BanchModel> branchList = [];
  ServicePackageState({this.servicePackagePaging, this.clinicBranch});
}

abstract class ServicePackageEvent {}

class EventLoadServicePackage extends ServicePackageEvent {}

class EventLoadMoreService extends ServicePackageEvent {}

// Event load goi kham tong quat
class EventLoadGeneralPackages extends ServicePackageEvent {}

class EventLoadMoreGeneralPackages extends ServicePackageEvent {}

// Event load goi kham tai nha

class EventLoadHomeExamPackages extends ServicePackageEvent {}

class EventLoadMoreHomeExamPackages extends ServicePackageEvent {}

// Event load goi kham khac

class EventLoadOtherServicePackages extends ServicePackageEvent {}

class EventLoadMoreOtherServicePackages extends ServicePackageEvent {}

// Event load chi nhanh trong goi kham

class EventLoadClinicBranch extends ServicePackageEvent {
  String clinicId;
  EventLoadClinicBranch({this.clinicId});
}

class EventLoadBranch extends ServicePackageEvent {
  String id;
  EventLoadBranch({this.id});
}

class LoadDetailServiceEvent extends ServicePackageEvent {
  String servicePackageId;
  String brandId;
  LoadDetailServiceEvent({this.servicePackageId, this.brandId});
}

class ServicePackageBloc
    extends BlocBase<ServicePackageEvent, ServicePackageState> {
  @override
  void initState() {
    this.state = ServicePackageState();

    super.initState();
  }

  @override
  Future<ServicePackageState> mapEventToState(ServicePackageEvent event) async {
    if (event is EventLoadServicePackage) {
      await _getServicePackage();
    } else if (event is LoadDetailServiceEvent) {
      await _getDetailService(event.servicePackageId, event.brandId);
    } else if (event is EventLoadMoreService) {
      var current = this.state.servicePackagePaging;
      await _addMoreService(current);
    } else if (event is EventLoadGeneralPackages) {
      await _getGeneralCheckUpPackages();
    } else if (event is EventLoadMoreGeneralPackages) {
      var current = this.state.servicePackagePaging;
      await _addMoreGeneralCheckUpPackages(current);
    } else if (event is EventLoadHomeExamPackages) {
      await _getHomeExamPackages();
    } else if (event is EventLoadMoreHomeExamPackages) {
      var current = this.state.servicePackagePaging;
      await _addMoreHomeExamPackages(current);
    } else if (event is EventLoadOtherServicePackages) {
      await _getOtherServicePackages();
    } else if (event is EventLoadMoreOtherServicePackages) {
      var current = this.state.servicePackagePaging;
      await _addMoreOtherServicePackages(current);
    } else if (event is EventLoadClinicBranch) {
      await _getClinicBranch(event.clinicId);
    } else if (event is EventLoadBranch) {
      await _getBranch(event.id);
    }

    return this.state;
  }

// tat ca goi kham
  Future _getServicePackage() async {
    final service = ServiceProxy();
    var current = this.state.servicePackagePaging;
    if (current == null) {
      current = PagingResult<ServicePackageOfCompanyModel>();
      this.state.servicePackagePaging = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }

    var res = await service.doctorCheckServiceProxy
        .getServicePackage(null, current.pageNumber = 1, current.pageSize = 10);
    this.state.servicePackagePaging = res;
  }

  Future _addMoreService(
      PagingResult<ServicePackageOfCompanyModel> model) async {
    final service = ServiceProxy().doctorCheckServiceProxy;
    var result = await service.getServicePackage(
        null, ++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
    } else if (result != null) {
      model.data.addAll(result.data);
    }
  }

  // goi kham tong quat
  Future _getGeneralCheckUpPackages() async {
    final service = ServiceProxy();
    var current = this.state.servicePackagePaging;
    if (current == null) {
      current = PagingResult<ServicePackageOfCompanyModel>();
      this.state.servicePackagePaging = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }

    var res = await service.doctorCheckServiceProxy.getGeneralCheckUpPackages(
        current.pageNumber = 1, current.pageSize = 10);
    this.state.servicePackagePaging = res;
  }

  Future _addMoreGeneralCheckUpPackages(
      PagingResult<ServicePackageOfCompanyModel> model) async {
    final service = ServiceProxy().doctorCheckServiceProxy;
    var result = await service.getGeneralCheckUpPackages(
        ++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
    } else if (result != null) {
      model.data.addAll(result.data);
    }
  }

  // goi kham tai nha
  Future _getHomeExamPackages() async {
    final service = ServiceProxy();
    var current = this.state.servicePackagePaging;
    if (current == null) {
      current = PagingResult<ServicePackageOfCompanyModel>();
      this.state.servicePackagePaging = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }

    var res = await service.doctorCheckServiceProxy
        .getHomeExamPackages(current.pageNumber = 1, current.pageSize = 10);
    this.state.servicePackagePaging = res;
  }

  Future _addMoreHomeExamPackages(
      PagingResult<ServicePackageOfCompanyModel> model) async {
    final service = ServiceProxy().doctorCheckServiceProxy;
    var result =
        await service.getHomeExamPackages(++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
    } else if (result != null) {
      model.data.addAll(result.data);
    }
  }

  // goi kham khac

  Future _getOtherServicePackages() async {
    final service = ServiceProxy();
    var current = this.state.servicePackagePaging;
    if (current == null) {
      current = PagingResult<ServicePackageOfCompanyModel>();
      this.state.servicePackagePaging = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }

    var res = await service.doctorCheckServiceProxy
        .getServicePackageOther(current.pageNumber = 1, current.pageSize = 10);
    this.state.servicePackagePaging = res;
  }

  Future _addMoreOtherServicePackages(
      PagingResult<ServicePackageOfCompanyModel> model) async {
    final service = ServiceProxy().doctorCheckServiceProxy;
    var result = await service.getServicePackageOther(
        ++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
    } else if (result != null) {
      model.data.addAll(result.data);
    }
  }

  Future _getDetailService(String id, String brandId) async {
    final service = ServiceProxy().packageServiceProxy;

    var res = await service.getDetailService(id);
    this.state.detailService = res;
    var medicalTest = await service.getMedicalTest(id, brandId);
    this.state.medicalTest = medicalTest.data;
    var physicalExam = await service.getPhysicalExam(id, brandId);
    this.state.physicalExam = physicalExam.data;
    var otherExam = await service.getOtherExam(id, brandId);
    this.state.otherExam = otherExam.data;
  }

  Future _getClinicBranch(String id) async {
    final service = ServiceProxy().clinicServiceProxy;
    var current = this.state.clinicBranch;
    if (current == null) {
      current = PagingResult<ClinicBranchModel>();
      this.state.clinicBranch = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    var res = await service.getClinicBranch(
        id, current.pageNumber = 1, current.pageSize = 10);
    this.state.clinicBranch = res;
  }

  //Get tat ca chi nhanh cua goi kham
  Future _getBranch(String id) async {
    final service = ServiceProxy().packageServiceProxy;

    var res = await service.getBranch(id);
    this.state.branchList = res.data;
  }
}
