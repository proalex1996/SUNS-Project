import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/bmi_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/calendar_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/clinic_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/create_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/detail_hospital_item_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/doctor_popular_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/appointment_history_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/favorite_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/feedback_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/hospital_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/order_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/order_result.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/ratecomment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/result_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';

class HospitalServiceProxy {
  HttpClient client;
  AppAuthService appAuthService;

  HospitalServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) {
    this.client = HttpClient(
      baseUrl: baseUrl,
      prefix: "/api/v1/Hospital",
      appAuthService: appAuthService,
    );
  }

  Future<List<DoctorPopularModel>> getDoctorPopular(String id) async {
    var res = await client.get("/get-doctor-popular?city=$id");
    var data = new List<DoctorPopularModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new DoctorPopularModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<HospitalModel>> getHospital(String id, int type) async {
    var res = await client.get("/get-data-by-type?city=$id&type=$type");
    var data = new List<HospitalModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new HospitalModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<HospitalModel>> getHospitalPopular(String id) async {
    var res = await client.get("/get-hospital-popular?city=$id");

    var data = new List<HospitalModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new HospitalModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<ClinicModel>> getClinic() async {
    var res = await client.get("/get-data-by-type?city=701&type=3");

    var data = new List<ClinicModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new ClinicModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<ClinicModel>> getClinicPopular(String id) async {
    var res = await client.get("/get-clinic-popular?city=$id");

    var data = new List<ClinicModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new ClinicModel.fromJson(v));
      });
    }

    return data;
  }

  Future<DetailHospitalModel> getDetailDoctor(String city, int id) async {
    var res = await client.get("/get-data-by-id?city=$city&id=$id&type=1");
    var detailDoctor = DetailHospitalModel.fromJson(res);

    return detailDoctor;
  }

  Future<List<AppointmentModel>> getAppointment(String sdt) async {
    var res =
        await client.get("/get-appointment-list-by-username?user_name=$sdt");
    var data = new List<AppointmentModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new AppointmentModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<RelationshipModel>> getRelationShip() async {
    var res = await client.get("/get-relationship");
    var data = new List<RelationshipModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new RelationshipModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<AppointmentHistoryModel>> getAppointmentHistory(
      String userName) async {
    var res = await client.get("/get-family-exam-history?user_name=$userName");
    var data = new List<AppointmentHistoryModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new AppointmentHistoryModel.fromJson(v));
      });
    }

    return data;
  }

  Future<BMIModel> getBMI(String id) async {
    var res = await client.get("/get-health-info?user_name=$id");
    var data = BMIModel.fromJson(res);

    return data;
  }

  Future<ResultModel> getResult(int id, String user) async {
    var res = await client.get(
        "/get-family-exam-history-result-by-orderno?user_name=$user&family_id=$id");
    var data = ResultModel.fromJson(res);

    return data;
  }

  Future feedback(FeedbackModel model) async {
    print(jsonEncode(model.toJson()));
    await client.post("/feedback", jsonEncode(model.toJson()));
  }

  Future<List<FavoriteModel>> getFavorite() async {
    var res = await client.get("/get-like-by-user");
    var data = new List<FavoriteModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new FavoriteModel.fromJson(v));
      });
    }

    return data;
  }

  Future<OrderResult> createOrder(OrderModel orderModel) async {
    print(jsonEncode(orderModel.toJson()));
    var res =
        await client.post("/create-order", jsonEncode(orderModel.toJson()));

    var data = OrderResult.fromJson(res);

    return data;
  }

  Future<List<CalendarModel>> getCalendar() async {
    var res = await client
        .get("/get-calendar-by-clinic?clinicid=1&type=1&service_id=1");
    var data = List<CalendarModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new CalendarModel.fromJson(v));
      });
    }

    return data;
  }

  Future postComment(RateCommentModel rateCommentModel) async {
    print(jsonEncode(rateCommentModel.toJson()));
    await client.post("/rate-comment", jsonEncode(rateCommentModel.toJson()));
  }

  Future createAppointment(
      CreateAppointmentModel createAppointmentModel) async {
    print(jsonEncode(createAppointmentModel.toJson()));
    await client.post(
        "/appointment", jsonEncode(createAppointmentModel.toJson()));
  }
}
