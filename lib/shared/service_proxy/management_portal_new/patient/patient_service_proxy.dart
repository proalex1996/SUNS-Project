import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/patient/dto/patient_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class PatientServiceProxy {
  HttpClient client;
  AppAuthService appAuthService;

  PatientServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) {
    this.client = HttpClient(
      baseUrl: baseUrl,
      prefix: "/api/v1/Patient",
      appAuthService: appAuthService,
    );
  }

  Future<PagingResult<PatientModel>> getTotalCost(int id) async {
    var res = await client.get("/$id/TotalCost?pageNumber=1&pageSize=10");
    if (res != null) {
      var result = new PagingResult<PatientModel>.fromJson(
          res, (v) => new PatientModel.fromJson(v));

      return result;
    }

    return null;
  }
}
