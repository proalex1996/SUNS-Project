import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/doctor_hospital_clinic_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/equipment/dto/equipment_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class ProvinceServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  ProvinceServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/Province");

  Future<PagingResult<ListDHCModel>> getListDHC(String id, String type) async {
    var res = await client.get("/$id/$type?pageNumber=1&pageSize=10");
    if (res != null) {
      var result = PagingResult<ListDHCModel>.fromJson(
          res, (v) => new ListDHCModel.fromJson(v));
      print(result.data);

      return result;
    }

    return null;
  }

  Future<PagingResult<EquipmentModel>> getListEquipment(String id) async {
    var res = await client.get("/$id/Equipment?pageNumber=1&pageSize=10");
    if (res != null) {
      var result = new PagingResult<EquipmentModel>.fromJson(
          res, (v) => new EquipmentModel.fromJson(v));
      return result;
    }

    return null;
  }

  Future<PagingResult<ListDHCModel>> getListDHCByDepartment(
      String id, String type, int departmentId) async {
    var res = await client.get(
        "/$id/$type?departmentSpecialId=$departmentId&pageNumber=1&pageSize=10");
    if (res != null) {
      var result = PagingResult<ListDHCModel>.fromJson(
          res, (v) => new ListDHCModel.fromJson(v));
      print(result.data);

      return result;
    }

    return null;
  }

  Future<PagingResult<ListDHCModel>> searchCompany(
      String id, String keyword) async {
    var res = await client
        .get("/$id/company?keyword=$keyword&pageNumber=1&pageSize=10");
    if (res != null) {
      var result = PagingResult<ListDHCModel>.fromJson(
          res, (v) => new ListDHCModel.fromJson(v));

      return result;
    }

    return null;
  }

  Future<PagingResult<ListDHCModel>> getAllCompany(String id) async {
    var res = await client.get("/$id/company?pageNumber=1&pageSize=10");
    if (res != null) {
      var result = PagingResult<ListDHCModel>.fromJson(
          res, (v) => new ListDHCModel.fromJson(v));

      return result;
    }

    return null;
  }

  Future<PagingResult<ListDHCModel>> getCompanyByDepartment(
      String provinceId, int id) async {
    var res = await client.get(
        "/$provinceId/company?departmentSpecialId=$id&pageNumber=1&pageSize=10");
    if (res != null) {
      var result = PagingResult<ListDHCModel>.fromJson(
          res, (v) => new ListDHCModel.fromJson(v));

      return result;
    }

    return null;
  }

  Future<PagingResult<ListDHCModel>> getListSearchCompanyByCompany(
      String provinceId, String companyType, String keyword) async {
    var res = await client.get(
        "/$provinceId/$companyType?keyword=$keyword&pageNumber=1&pageSize=10");
    if (res != null) {
      var result = PagingResult<ListDHCModel>.fromJson(
          res, (v) => new ListDHCModel.fromJson(v));

      return result;
    }

    return null;
  }

  Future<PagingResult<ListDHCModel>> getListSearchCompanyByDepartment(
      String provinceId, int departmentSpecialId, String keyword) async {
    var res = await client.get(
        "/$provinceId/company?departmentSpecialId=$departmentSpecialId&keyword=$keyword&pageNumber=1&pageSize=10");
    if (res != null) {
      var result = PagingResult<ListDHCModel>.fromJson(
          res, (v) => new ListDHCModel.fromJson(v));
      return result;
    }
    return null;
  }
}
