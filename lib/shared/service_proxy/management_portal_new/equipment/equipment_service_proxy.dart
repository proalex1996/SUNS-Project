import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/equipment/dto/equipment_model.dart';

class EquipmentServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  EquipmentServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/Equipment");

  Future<EquipmentModel> getDetailEquipment(String id) async {
    var res = await client.get("/$id");
    var data = EquipmentModel.fromJson(res);
    return data;
  }

  Future<bool> hasLikeEquipment(String id) async {
    var res = await client.get("/$id/HasLike");
    return res;
  }

  Future<bool> likeEquipment(String id) async {
    var res = await client.post("/$id/Like", jsonEncode(null));
    return res;
  }

  Future<bool> unlikeEquipment(String id) async {
    var res = await client.delete("/$id/Like");
    return res;
  }

  Future<bool> shareEquipment(String id) async {
    var res = await client.post("/$id/Share", jsonEncode(null));
    return res;
  }
}
