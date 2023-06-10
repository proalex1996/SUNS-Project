import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/date_off_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/doctor_hospital_clinic_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/post_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/prescription_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/rating_input.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class CompanyServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  CompanyServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1");

  Future<String> postAppointment(
    PostAppointmentModel postAppointmentModel,
  ) async {
    var res =
        await client.post("/Appointment", jsonEncode(postAppointmentModel));
    return res;
  }

  Future<bool> postPrescription(
      String appointmentId, PrescriptionModel prescription) async {
    var res = await client.post(
        "/Appointment/$appointmentId/Prescription", jsonEncode(prescription));
    return res;
  }

  Future<bool> allowedRating(String companyId, String companyType) async {
    var res = await client.get("/$companyType/$companyId/AllowedRating");
    return res;
  }

  Future<bool> postComment(RatingInput rateCommentModel, String companyType,
      String companyId) async {
    // print(jsonEncode(rateCommentModel.toJson()));
    var res = await client.post("/$companyType/$companyId/Rating",
        jsonEncode(rateCommentModel.toJson()));
    return res;
  }

  Future<PagingResult<ListDHCModel>> getCompanySimilar(
      String companyType, String id, int pageNum, int pageSize) async {
    var res = await client.get(
        "/$companyType/$id/Similar?pageNumber=$pageNum&pageSize=$pageSize");
    if (res != null) {
      var result = PagingResult<ListDHCModel>.fromJson(
          res, (v) => new ListDHCModel.fromJson(v));
      print(result.data);

      return result;
    }

    return null;
  }

  Future<DayOffModel> getDayOffCompany(String companyId) async {
    var res = await client.get('/Clinic/$companyId/DayOff');
    var dayoff = DayOffModel.fromJson(res);
    return dayoff;
  }
}
