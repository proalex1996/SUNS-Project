import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/banner_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/input_ordinalnumber_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/user-form-qr_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/user_report_model.dart';
import 'dto/qr_model.dart';

class NewCommonServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  NewCommonServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/Common");

  Future<List<NewBannerModel>> getAllBanner() async {
    var res = await client.get("/Banner");
    var data = new List<NewBannerModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new NewBannerModel.fromJson(v));
      });
    }

    return data;
  }

  Future<bool> inputOrdinalNumber(
      InputPrintOrdinalNumberModel printOrdinalNumberModel) async {
    var res = await client.post(
        '/PrintOrdinalNumber', jsonEncode(printOrdinalNumberModel));
    return res;
  }

  Future<UserFromQrCodeModel> inputQrCode(QrModel qrModel) async {
    var res = await client.post("/HealthInsuranceQRCode", jsonEncode(qrModel));

    return res;
  }

  Future<UserSupportModel> getUserSupport() async {
    var res = await client.get("/UserSupport");
    if (res == null)
      return null;
    else {
      var data = UserSupportModel.fromJson(res);
      return data;
    }
  }

  Future<String> getBackground() async {
    var res = await client.get("/UserBackgroundImage");
    //var data = res.
    return res;
  }

  Future<String> getHotline() async {
    var res = await client.get("/Hotline");
    return res;
  }
}
