import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/service_package_company_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class DoctorCheckServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  DoctorCheckServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1");

  Future<PagingResult<ServicePackageOfCompanyModel>> getServicePackagePopular(
      int pageNumber, int pageSize) async {
    var res = await client
        .get("/ServicePackage?featured=true&pageNumber=$pageNumber&pageSize=$pageSize");
    if (res != null) {
      var data = PagingResult<ServicePackageOfCompanyModel>.fromJson(
          res, (v) => ServicePackageOfCompanyModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<PagingResult<ServicePackageOfCompanyModel>> getServicePackage(
      String keyword, int pageNumber, int pageSize) async {
    var keyWord = keyword == null ? "" : "name=$keyword&";
    var res = await client.get(
        "/ServicePackage?${keyWord}pageNumber=$pageNumber&pageSize=$pageSize");
    if (res != null) {
      var data = PagingResult<ServicePackageOfCompanyModel>.fromJson(
          res, (v) => ServicePackageOfCompanyModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<PagingResult<ServicePackageOfCompanyModel>> getGeneralCheckUpPackages(
      int pageNumber, int pageSize) async {
    var res = await client.get(
        "/ServicePackage?type=1&pageNumber=$pageNumber&pageSize=$pageSize");
    if (res != null) {
      var data = PagingResult<ServicePackageOfCompanyModel>.fromJson(
          res, (v) => ServicePackageOfCompanyModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<PagingResult<ServicePackageOfCompanyModel>> getHomeExamPackages(
      int pageNumber, int pageSize) async {
    var res = await client.get(
        "/ServicePackage?type=2&pageNumber=$pageNumber&pageSize=$pageSize");
    if (res != null) {
      var data = PagingResult<ServicePackageOfCompanyModel>.fromJson(
          res, (v) => ServicePackageOfCompanyModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<PagingResult<ServicePackageOfCompanyModel>> getServicePackageOther(
      int pageNumber, int pageSize) async {
    var res = await client.get(
        "/ServicePackage?type=0&pageNumber=$pageNumber&pageSize=$pageSize");
    if (res != null) {
      var data = PagingResult<ServicePackageOfCompanyModel>.fromJson(
          res, (v) => ServicePackageOfCompanyModel.fromJson(v));

      return data;
    }
    return null;
  }
}
