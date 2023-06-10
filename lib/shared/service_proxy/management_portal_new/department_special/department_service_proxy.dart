import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/department_special/dto/department_model.dart';

class DepartmentServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  DepartmentServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(appAuthService: appAuthService, baseUrl: baseUrl);

  Future<List<DepartmentModel>> getAllDepartment() async {
    var res = await client.get("/DepartmentSpecial");
    var data = new List<DepartmentModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new DepartmentModel.fromJson(v));
      });
    }

    return data;
  }
}
