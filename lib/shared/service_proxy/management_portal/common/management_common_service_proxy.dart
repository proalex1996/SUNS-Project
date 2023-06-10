import 'package:flutter/foundation.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal/common/dto/banner_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/common/dto/department_special_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/common/dto/medical_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/common/dto/notify_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/hospital_model.dart';

class ManagementCommonServiceProxy {
  HttpClient client;
  AppAuthService appAuthService;

  ManagementCommonServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) {
    this.client = HttpClient(
      baseUrl: baseUrl,
      prefix: "/api/v1/Common",
      appAuthService: appAuthService,
    );
  }

  Future<List<BannerModel>> getAllBanner() async {
    var res = await client.get("/get-banner");
    var data = new List<BannerModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new BannerModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<DepartmentSpecialModel>> getAllDepartment() async {
    var res = await client.get("/get-department-special");
    var data = new List<DepartmentSpecialModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new DepartmentSpecialModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<MedicalModel>> getMedical() async {
    var res = await client.get("/search?page_no=1&city=701&type=0");
    var data = new List<MedicalModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new MedicalModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<NotifyModel>> getNotifyModel() async {
    var res = await client.get("/get-all-notify");
    var data = new List<NotifyModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new NotifyModel.fromJson(v));
      });
    }

    return data;
  }

  Future<int> getUnReadNotify() async {
    var data = await client.get("/get-total-unread-notify?lang=vi");
    return data;
  }

  Future<List<HospitalModel>> doctorByDepartment(String department) async {
    var res = await client.get(
        "/get-department-special-by?page_no=1&city=701&department=$department");
    var data = new List<HospitalModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new HospitalModel.fromJson(v));
      });
    }
    return data;
  }
}
