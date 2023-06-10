import 'package:flutter/material.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/contact/dto/heal_chart_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/contact/dto/medical_examination_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class ContactSeviceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  ContactSeviceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(appAuthService: appAuthService, baseUrl: baseUrl);

  Future<int> getTotalCost(int id) async {
    var res = await client.get("/Contact/$id/TotalCost");

    return res;
  }

  Future syncExamResult() async {
    var res = await client.post("/Contact/SyncExamResult", null);

    return res;
  }

  Future<PagingResult<MedicalExaminationModel>> getMedicalExamination(
      int id) async {
    var res = await client
        .get("/Contact/$id/MedicalExamination?pageNumber=1&pageSize=10");

    if (res != null) {
      var result = new PagingResult<MedicalExaminationModel>.fromJson(
          res, (v) => new MedicalExaminationModel.fromJson(v));

      return result;
    }
    return null;
  }

  Future<List<HealthChartModel>> getHealthChart(int idContact) async {
    var res = await client.get("/Contact/$idContact/Health");
    var data = List<HealthChartModel>();
    if (res != null) {
      res.forEach((v) {
        data.add(HealthChartModel.fromJson(v));
      });
    }

    return data;
  }
}
