import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/detail_dhc_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/rating_company_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/service_package_company_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class DoctorServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  DoctorServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/Doctor");

  Future<DetailDHCModel> getDetailDHC(String id) async {
    var res = await client.get("/$id");
    var detailDoctor = DetailDHCModel.fromJson(res);
    return detailDoctor;
  }

  Future<PagingResult<ServicePackageOfCompanyModel>> getDataService(
      String id, int pageNum, int pageSize) async {
    var res = await client
        .get("/$id/ServicePackage?pageNumber=$pageNum&pageSize=$pageSize");
    if (res != null) {
      var result = PagingResult.fromJson(
          res, (v) => new ServicePackageOfCompanyModel.fromJson(v));

      return result;
    }

    return null;
  }

  Future<bool> hasLikeDoctor(String id) async {
    var res = await client.get("/$id/HasLike");
    return res;
  }

  Future<bool> likeDoctor(String id) async {
    var res = await client.post("/$id/Like", jsonEncode(null));
    return res;
  }

  Future<bool> unlikeDoctor(String id) async {
    var res = await client.delete("/$id/Like");
    return res;
  }

  Future<PagingResult<RatingOfCompanyModel>> getListRating(String id) async {
    var res = await client.get("/$id/Rating?pageNumber=1&pageSize=10");
    if (res != null) {
      var result = PagingResult.fromJson(
          res, (v) => new RatingOfCompanyModel.fromJson(v));

      return result;
    }

    return res;
  }
}
