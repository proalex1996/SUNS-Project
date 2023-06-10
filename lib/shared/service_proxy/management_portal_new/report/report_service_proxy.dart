import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';

import 'dto/user-summary-report-model.dart';

class ReportServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  ReportServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1");

  Future<UserSummaryReportModel> getUserSummanyReport() async {
    var res = await client.get("/Report/UserSummaryReport");
    var data = UserSummaryReportModel.fromJson(res);
    return data;
  }
}
