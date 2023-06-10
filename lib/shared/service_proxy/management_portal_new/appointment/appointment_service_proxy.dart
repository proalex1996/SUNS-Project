import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/cancel_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/detail_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/exam_service_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/input_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/reschedule_model.dart';
import 'package:suns_med/shared/service_proxy/paging_query.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class AppointmentServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  AppointmentServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/Appointment");

  Future<PagingResult<AppointmentNewsModel>> getAppointmentNews(
      int pageNum, int pageSize, AppointmentFilterQuery filterQuery) async {
    var pagingQuery = PagingQuery(
        pageNumber: pageNum,
        pageSize: pageSize,
        dataFilter: filterQuery?.toJson());
    var res = await client.get(pagingQuery.toString());

    if (res != null) {
      var result = new PagingResult<AppointmentNewsModel>.fromJson(
          res, (v) => new AppointmentNewsModel.fromJson(v));

      return result;
    }

    return null;
  }

  Future<DetailAppointmentModel> getDetailAppointment(String id) async {
    var res = await client.get("/$id");
    var result = DetailAppointmentModel.fromJson(res);
    return result;
  }

  Future<bool> getAllowAcceptRequestReject(String id) async {
    var res = await client.get("/$id/AllowAcceptRequestReject");
    return res;
  }

  Future<bool> postAcceptRequestReject(String id) async {
    var res = await client.post("/$id/AcceptRequestReject", jsonEncode(null));
    return res;
  }

  Future<PagingResult<ExamServicesModel>> getExamServices(
      String id, int pageNum, int pageSize) async {
    var res = await client
        .get('/$id/ExamServices?pageNumber=$pageNum&pageSize=$pageSize');
    if (res != null) {
      var result = new PagingResult<ExamServicesModel>.fromJson(res, (v) {
        return new ExamServicesModel.fromJson(v);
      });

      return result;
    }
    return null;
  }

  Future<bool> rescheduleAppoinment(
      String appointmentId, RescheduleModel reschedule) async {
    var res =
        await client.post("/$appointmentId/Reschedule", jsonEncode(reschedule));
    return res;
  }

  Future<bool> cancelAppointment(
      String appointmentId, CancelAppointmentModel cancelAppointment) async {
    var res = await client.post(
        '/$appointmentId/Cancel', jsonEncode(cancelAppointment.toJson()));

    return res;
  }
}

class AppointmentFilterQuery {
  AppointmentFilterQuery({
    this.appointmentTime,
    this.appointmentStatuses,
  });

  DateTime appointmentTime;
  List<int> appointmentStatuses;

  factory AppointmentFilterQuery.fromJson(Map<String, dynamic> json) =>
      AppointmentFilterQuery(
        appointmentTime: json["appointmentTime"] != null
            ? DateTime.parse(json["appointmentTime"])
            : null,
        appointmentStatuses: json["appointmentStatuses"] != null
            ? List<int>.from(json["appointmentStatuses"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "appointmentTime": appointmentTime?.toIso8601String(),
        "appointmentStatuses": appointmentStatuses != null
            ? List<dynamic>.from(appointmentStatuses.map((x) => x))
            : null,
      };
}
