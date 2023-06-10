import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/medicalexamination/dto/detail_medicalexam_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/medicalexamination/dto/examination_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/medicalexamination/dto/input_rating_model.dart';

class MedicalExaminationServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  MedicalExaminationServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(appAuthService: appAuthService, baseUrl: baseUrl);

  Future<DetailMedicalExaminationModel> getDetailMedicalExamination(
      String id) async {
    var res = await client.get("/MedicalExamination/$id");
    var result = new DetailMedicalExaminationModel.fromJson(res);

    return result;
  }

  Future<List<ExaminationModel>> getExamination(String id) async {
    var res = await client.get("/MedicalExamination/$id/Examination");
    var result = new List<ExaminationModel>();

    if (res != null) {
      res.forEach((v) {
        result.add(new ExaminationModel.fromJson(v));
      });
    }

    return result;
  }

  Future<bool> getAllowedRating(String idExamination) async {
    var res =
        await client.get("/MedicalExamination/$idExamination/AllowedRating");
    return res;
  }

  Future<bool> postComment(
      InputRatingCommentModel inputRatingComment, String id) async {
    print(jsonEncode(inputRatingComment.toJson()));
    var res = await client.post("/MedicalExamination/$id/Rating",
        jsonEncode(inputRatingComment.toJson()));

    return res;
  }
}
