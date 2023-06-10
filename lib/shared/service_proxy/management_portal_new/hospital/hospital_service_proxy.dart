import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/detail_dhc_model.dart';

class HospitalNewServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  HospitalNewServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: '/api/v1/Hospital');
  Future<DetailDHCModel> getDetailDHC(String id) async {
    var res = await client.get("/$id");
    var detailHospital = DetailDHCModel.fromJson(res);
    return detailHospital;
  }

  Future<bool> hasLikeHospital(String id) async {
    var res = await client.get("/$id/HasLike");
    return res;
  }

  Future<bool> likeHospital(String id) async {
    var res = await client.post("/$id/Like", jsonEncode(null));
    return res;
  }

  Future<bool> unlikeHospital(String id) async {
    var res = await client.delete("/$id/Like");
    return res;
  }
}
