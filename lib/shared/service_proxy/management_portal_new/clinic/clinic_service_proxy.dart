import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/detail_dhc_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/clinic/dto/clinic_branch_model.dart';

class ClinicServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  ClinicServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/Clinic");

  Future<DetailDHCModel> getDetailDHC(String id) async {
    var res = await client.get("/$id");
    var detailClinic = DetailDHCModel.fromJson(res);
    return detailClinic;
  }

  Future<bool> hasLikeClinic(String id) async {
    var res = await client.get("/$id/HasLike");
    return res;
  }

  Future<bool> likeClinic(String id) async {
    var res = await client.post("/$id/Like", jsonEncode(null));
    return res;
  }

  Future<bool> unlikeClinic(String id) async {
    var res = await client.delete("/$id/Like");
    return res;
  }

  Future<PagingResult<ClinicBranchModel>> getClinicBranch(
      String id, int pageNum, int pageSize) async {
    var res =
        await client.get("/$id/Branch?pageNumber=$pageNum&pageSize=$pageSize");
    if (res != null) {
      var result =
          PagingResult.fromJson(res, (v) => new ClinicBranchModel.fromJson(v));

      return result;
    }

    return null;
  }
}
