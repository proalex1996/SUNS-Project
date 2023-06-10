import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/working_time_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/staff/dto/staff_detail_model.dart';

class StaffServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  StaffServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/Staff");

  Future<List<WorkingTimeModel>> getWorkingTime(
      String id, DateTime dateTime) async {
    var res = await client.get("/$id/WorkingTime?date=$dateTime");
    var data = new List<WorkingTimeModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(WorkingTimeModel.fromJson(v));
      });
    }

    return data;
  }

  Future<StaffDetailModel> getDetailDoctor(String idDoctor) async {
    var res = await client.get("/$idDoctor");
    var data = StaffDetailModel.fromJson(res);
    return data;
  }
}
