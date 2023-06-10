import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/confirm_apppay_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/create_momo_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/create_momo_result.dart';
import 'package:suns_med/shared/service_proxy/log_portal/momo_payment/dto/deep_link_model.dart';

class MomoServiceProxy {
  HttpClient client;
  AppAuthService appAuthService;

  MomoServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) {
    this.client = HttpClient(
      baseUrl: baseUrl,
      prefix: "/api/momo",
      appAuthService: appAuthService,
    );
  }

  Future<CreateMomoResult> createMomo(CreateMomoModel model) async {
    print(jsonEncode(model.toJson()));
    var result =
        await client.post("/CreatePaymentUrl", jsonEncode(model.toJson()));
    var momoResult = CreateMomoResult.fromJson(result);

    return momoResult;
  }

  Future getDeepLink() async {
    var result = await client.get("/GetDeepLink");
    var data = new DeepLinkModel.fromJson(result);
    return data;
  }

  Future createConfirmPay(ConfirmAppPayMomoModel confirmAppPayMomoModel) async {
    print(jsonEncode(confirmAppPayMomoModel.toJson()));
    var res = await client.post("url", confirmAppPayMomoModel.toJson());
    return res;
  }
}
