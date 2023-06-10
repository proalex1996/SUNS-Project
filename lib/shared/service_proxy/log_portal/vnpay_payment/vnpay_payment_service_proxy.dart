import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/log_portal/vnpay_payment/dto/vnpay_model.dart';

class VNPayServiceProxy {
  HttpClient client;
  AppAuthService appAuthService;

  VNPayServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) {
    this.client = HttpClient(
      baseUrl: baseUrl,
      prefix: "/api/vnpay",
      appAuthService: appAuthService,
    );
  }

  Future<String> createVNPay(VNPayModel model) async {
    print(jsonEncode(model.toJson()));
    var result =
        await client.post("/CreatePaymentUrl", jsonEncode(model.toJson()));
    var vnPayResult = result;

    return vnPayResult;
  }

  Future confirmPayment(String query) async {
    var result = await client.get("/ConfirmPayment?$query");
    print(result);
    return result;
  }
}
