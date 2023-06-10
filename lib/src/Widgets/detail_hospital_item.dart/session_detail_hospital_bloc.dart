import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/detail_hospital_item_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/date_off_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/detail_dhc_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/doctor_hospital_clinic_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/rating_company_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/rating_input.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/service_package_company_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/dto/detail_service_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_rating_model.dart';

class DetailItemState {
  DetailHospitalModel detailItem;
  DetailDHCModel detailDHC;
  List<ListDHCModel> listCompanySimilar;
  PagingResult<ServicePackageOfCompanyModel> listServiceOfCompany;
  List<RatingOfCompanyModel> listRatingOfCompany;
  DetailServiceModel detailService;
  bool hasLike;
  bool allowedRating;
  bool isRated;
  List<UserRatingModel> listUserRating;
  UserRatingModel userRating;
  int pageSizeServicePackage;
  DayOffModel dayOff;
  DetailItemState(
      {this.detailItem,
      this.detailDHC,
      this.allowedRating,
      this.listUserRating,
      this.listServiceOfCompany,
      this.listRatingOfCompany,
      this.pageSizeServicePackage,
      this.listCompanySimilar,
      this.hasLike,
      this.isRated = false,
      this.userRating,
      this.dayOff,
      this.detailService});
}

enum CompanyType { None, Doctor, Clinic, Hospital, Equipment }

abstract class DetailItemEvent {}

class LoadDetailItemEvent extends DetailItemEvent {
  int id;
  String city;
  LoadDetailItemEvent({this.id, this.city});
}

class LoadDetailDoctorEvent extends DetailItemEvent {
  String id;
  List<int> userIds;
  LoadDetailDoctorEvent({this.id, this.userIds});
}

class LoadDetailHospitalEvent extends DetailItemEvent {
  String id;
  List<int> userIds;
  LoadDetailHospitalEvent({this.id, this.userIds});
}

class LoadDetailClinicEvent extends DetailItemEvent {
  String id;
  List<int> userIds;
  LoadDetailClinicEvent({this.id, this.userIds});
}

class LikeDoctor extends DetailItemEvent {
  String id;
  LikeDoctor({this.id});
}

class UnlikeDoctor extends DetailItemEvent {
  String id;
  UnlikeDoctor({this.id});
}

class LikeHospital extends DetailItemEvent {
  String id;
  LikeHospital({this.id});
}

class UnlikeHospital extends DetailItemEvent {
  String id;
  UnlikeHospital({this.id});
}

class LikeClinic extends DetailItemEvent {
  String id;
  LikeClinic({this.id});
}

class UnlikeClinic extends DetailItemEvent {
  String id;
  UnlikeClinic({this.id});
}

class EventPostUserId extends DetailItemEvent {
  List<int> userIds;
  EventPostUserId({this.userIds});
}

class EventPostInputRating extends DetailItemEvent {
  final RatingInput rateCommentModel;
  final String companyType, companyId;

  EventPostInputRating(
      {this.rateCommentModel, this.companyType, this.companyId});
}

class EventLoadCompanySimilar extends DetailItemEvent {
  final String id;
  EventLoadCompanySimilar({this.id});
}

class EventResetIsRated extends DetailItemEvent {}

class EventCallListRating extends DetailItemEvent {
  final String id;
  EventCallListRating({this.id});
}

class EventGetAllServicePackage extends DetailItemEvent {
  final String id;
  final int pageNum, pageSize;
  EventGetAllServicePackage({this.id, this.pageNum, this.pageSize});
}

class EventLoadDayOff extends DetailItemEvent {}

class DetailItemBloc extends BlocBase<DetailItemEvent, DetailItemState> {
  static final DetailItemBloc _instance = DetailItemBloc._internal();
  DetailItemBloc._internal();

  factory DetailItemBloc() {
    return _instance;
  }
  RatingInput _rateComment = RatingInput();
  @override
  void initState() {
    this.state = new DetailItemState();
    super.initState();
  }

  @override
  Future<DetailItemState> mapEventToState(DetailItemEvent event) async {
    if (event is LoadDetailDoctorEvent) {
      await _getDoctorDetail(event.id);
      await _getHasLikeDoctor(event.id);
      await _getListServiceOfCompany(this.state.detailDHC.id);
      await _getListRatingOfCompany(this.state.detailDHC.id);
      await _getDoctorSimilar(event.id);
      // await _getUserRating(event.userIds);
    } else if (event is LoadDetailHospitalEvent) {
      await _getHospitalDetail(event.id);
      await _getHasLikeHospital(event.id);
      await _getListServiceOfCompany(this.state.detailDHC.id);
      await _getListRatingOfCompany(this.state.detailDHC.id);
      await _getHospitalSimilar(event.id);
      // await _getUserRating(event.userIds);
    } else if (event is LoadDetailClinicEvent) {
      await _getClinicDetail(event.id);
      await _getHasLikeClinic(event.id);
      await _getListServiceOfCompany(this.state.detailDHC.id);
      await _getListRatingOfCompany(this.state.detailDHC.id);
      await _getClinicSimilar(event.id);
      // await _getUserRating(event.userIds);
    } else if (event is LikeDoctor) {
      await _likeDoctor(event.id);
    } else if (event is UnlikeDoctor) {
      await _unlikeDoctor(event.id);
    } else if (event is LikeHospital) {
      await _likeHospital(event.id);
    } else if (event is UnlikeHospital) {
      await _unlikeHospital(event.id);
    } else if (event is LikeClinic) {
      await _likeClinic(event.id);
    } else if (event is UnlikeClinic) {
      await _unlikeClinic(event.id);
    } else if (event is EventPostInputRating) {
      await _postCommentRating(
          event.rateCommentModel, event.companyType, event.companyId);
    } else if (event is EventPostUserId) {
      await _getUserRating(event.userIds);
    } else if (event is EventResetIsRated) {
      this.state.isRated = false;
    } else if (event is EventCallListRating) {
      await _getListRatingOfCompany(event.id);
    } else if (event is EventGetAllServicePackage) {
      // var pageSize = this.state.pageSizeServicePackage;
      await _getMoreAllServicePackage(
          this.state.detailDHC.id, 1, event.pageSize);
    } else if (event is EventLoadDayOff) {
      await _getDayOffCompany();
    }
    //  else if (event is EventLoadCompanySimilar) {
    //   await _getCompanySimilar(event.id);
    // }

    return this.state;
  }

  Future _getDoctorDetail(String id) async {
    final service = ServiceProxy();
    this.state.detailDHC = await service.doctorServiceProxy.getDetailDHC(id);
    this.state.allowedRating = await service.companyServiceProxy
        .allowedRating(this.state.detailDHC.id, "Doctor");
    // var res = await service.companyServiceProxy
    //     .getDayOffCompany("Doctor", this.state.detailDHC.id);
    // this.state.dayOff = res;
  }

  Future _getHospitalDetail(String id) async {
    final service = ServiceProxy();
    this.state.detailDHC =
        await service.hospitalNewServiceProxy.getDetailDHC(id);
    this.state.allowedRating = await service.companyServiceProxy
        .allowedRating(this.state.detailDHC.id, "Hospital");
    // var res = await service.companyServiceProxy
    //     .getDayOffCompany("Hospital", this.state.detailDHC.id);
    // this.state.dayOff = res;
  }

  Future _getClinicDetail(String id) async {
    final service = ServiceProxy();
    this.state.detailDHC = await service.clinicServiceProxy.getDetailDHC(id);
    this.state.allowedRating = await service.companyServiceProxy
        .allowedRating(this.state.detailDHC.id, "Clinic");
    // var res = await service.companyServiceProxy
    //     .getDayOffCompany("Clinic", "ef43c137-b3b6-43e0-24fc-08d8b2f27bbf");
    // this.state.dayOff = res;
  }

  Future _getListServiceOfCompany(String id) async {
    final service = ServiceProxy().doctorServiceProxy;
    var res = await service.getDataService(id, 1, 3);
    this.state.pageSizeServicePackage = res?.totalCount;
    this.state.listServiceOfCompany = res;
    // res = await service.getDataService(id, 1, res?.totalCount);
  }

  Future _getMoreAllServicePackage(String id, int pageNum, int pageSize) async {
    final service = ServiceProxy().doctorServiceProxy;
    this.state.listServiceOfCompany =
        await service.getDataService(id, pageNum, pageSize);
  }

  Future _getListRatingOfCompany(String id) async {
    final service = ServiceProxy();
    var res = await service.doctorServiceProxy.getListRating(id);
    this.state.listRatingOfCompany = res?.data;
    if (res?.data != null && res.data.length > 0) {
      this.state.listUserRating = await service.userService
          .getUserRating(res.data.map((e) => e.userId).toList());
    }

    // for (int i = 0; i < state.listUserRating.length; i++) {
    //   this.state.userRating = state.listUserRating[i];
    // }
  }

  // Future _getDetailService(String id) async {
  //   final service = ServiceProxy().packageServiceProxy;
  //   var res = await service.getDetailService(id);
  //   this.state.detailService = res;
  // }

  Future _getHasLikeDoctor(String id) async {
    final service = ServiceProxy().doctorServiceProxy;
    this.state.hasLike = await service.hasLikeDoctor(id);
  }

  Future _getHasLikeHospital(String id) async {
    final service = ServiceProxy().hospitalNewServiceProxy;
    this.state.hasLike = await service.hasLikeHospital(id);
  }

  Future _getHasLikeClinic(String id) async {
    final service = ServiceProxy().clinicServiceProxy;
    this.state.hasLike = await service.hasLikeClinic(id);
  }

  Future _likeDoctor(String id) async {
    final service = ServiceProxy().doctorServiceProxy;
    await service.likeDoctor(id);
    this.state.hasLike = await service.hasLikeDoctor(id);
  }

  Future _unlikeDoctor(String id) async {
    final service = ServiceProxy().doctorServiceProxy;
    await service.unlikeDoctor(id);
    this.state.hasLike = await service.hasLikeDoctor(id);
  }

  Future _likeHospital(String id) async {
    final service = ServiceProxy().hospitalNewServiceProxy;
    await service.likeHospital(id);
    this.state.hasLike = await service.hasLikeHospital(id);
  }

  Future _unlikeHospital(String id) async {
    final service = ServiceProxy().hospitalNewServiceProxy;
    await service.unlikeHospital(id);
    this.state.hasLike = await service.hasLikeHospital(id);
  }

  Future _likeClinic(String id) async {
    final service = ServiceProxy().clinicServiceProxy;
    await service.likeClinic(id);
    this.state.hasLike = await service.hasLikeClinic(id);
  }

  Future _unlikeClinic(String id) async {
    final service = ServiceProxy().clinicServiceProxy;
    await service.unlikeClinic(id);
    this.state.hasLike = await service.hasLikeClinic(id);
  }

  Future _postCommentRating(
      RatingInput rateComment, String companyType, String companyId) async {
    final service = ServiceProxy();

    if (rateComment.rating > 5) {
      _rateComment.rating = 5;
      _rateComment.comment = rateComment.comment;
    } else {
      _rateComment = rateComment;
    }

    var isRated = await service.companyServiceProxy
        .postComment(_rateComment, companyType, companyId);
    if (isRated == true) {
      this.state.isRated = isRated;
      var res = await service.doctorServiceProxy.getListRating(companyId);
      this.state.listRatingOfCompany = res?.data;
      if (res?.data != null && res.data.length > 0) {
        this.state.listUserRating = await service.userService
            .getUserRating(res.data.map((e) => e.userId).toList());
      }
    }
  }

  Future _getUserRating(List<int> userIds) async {
    final service = ServiceProxy().userService;
    this.state.listUserRating = await service.getUserRating(userIds);
  }

  Future _getDoctorSimilar(String id) async {
    final service = ServiceProxy().companyServiceProxy;
    var res = await service.getCompanySimilar("Doctor", id, 1, 10);
    this.state.listCompanySimilar = res?.data;
  }

  Future _getClinicSimilar(String id) async {
    final service = ServiceProxy().companyServiceProxy;
    var res = await service.getCompanySimilar("Doctor", id, 1, 10);
    this.state.listCompanySimilar = res?.data;
  }

  Future _getHospitalSimilar(String id) async {
    final service = ServiceProxy().companyServiceProxy;
    var res = await service.getCompanySimilar("Doctor", id, 1, 10);
    this.state.listCompanySimilar = res?.data;
  }

  Future _getDayOffCompany() async {
    // final service = ServiceProxy().companyServiceProxy;
    //Todo can api get company
    // var res = await service.getDayOffCompany(
    //     "Clinic", "ef43c137-b3b6-43e0-24fc-08d8b2f27bbf");
    // this.state.dayOff = res;
  }
}
