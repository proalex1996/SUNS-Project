import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/examination_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/staff_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/dto/detail_service_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/dto/branch_model.dart';

class PackageServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  PackageServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/ServicePackage");

  Future<DetailServiceModel> getDetailService(String id) async {
    var res = await client.get("/$id");
    var data = DetailServiceModel.fromJson(res);
    return data;
  }

  Future<PagingResult<StaffModel>> getStaffOfService(
      String serviceId, String branchId, DateTime dateTime) async {
    var res = await client.get(
        "/$serviceId/Staff?branchId=$branchId&selectedDate=$dateTime&pageNumber=1&pageSize=10");
    if (res != null) {
      var data = PagingResult<StaffModel>.fromJson(
          res, (v) => new StaffModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<PagingResult<ExaminationModel>> getMedicalTest(
      String id, String brandId) async {
    var res = await client
        .get("/$id/MedicalTest?pageNumber=1&pageSize=100&branchId=$brandId");
    if (res != null) {
      var data = PagingResult<ExaminationModel>.fromJson(
          res, (v) => new ExaminationModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<PagingResult<BanchModel>> getBranch(String id) async {
    var res = await client.get("/$id/Branch?pageNumber=1&pageSize=100");
    if (res != null) {
      var data = PagingResult<BanchModel>.fromJson(
          res, (v) => new BanchModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<PagingResult<ExaminationModel>> getPhysicalExam(
      String id, String brandId) async {
    var res = await client
        .get("/$id/PhysicalExam?pageNumber=1&pageSize=100&branchId=$brandId");
    if (res != null) {
      var data = PagingResult<ExaminationModel>.fromJson(
          res, (v) => new ExaminationModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<PagingResult<ExaminationModel>> getOtherExam(
      String id, String brandId) async {
    var res = await client
        .get("/$id/OtherExam?pageNumber=1&pageSize=100&branchId=$brandId");
    if (res != null) {
      var data = PagingResult<ExaminationModel>.fromJson(
          res, (v) => new ExaminationModel.fromJson(v));

      return data;
    }
    return null;
  }
}
