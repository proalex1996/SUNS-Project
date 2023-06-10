import 'package:flutter/material.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/like/dto/like_company.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/postnews_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class LikeServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  LikeServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(appAuthService: appAuthService, baseUrl: baseUrl);

  Future<PagingResult<LikeCompanyModel>> getLikeCompany() async {
    var res = await client.get("/Like/Company?pageNumber=1&pageSize=10");

    if (res != null) {
      var result = new PagingResult<LikeCompanyModel>.fromJson(
          res, (v) => new LikeCompanyModel.fromJson(v));
      return result;
    }
    return null;
  }

  Future<PagingResult<PostNewsModel>> getLikeNews() async {
    var res = await client.get("/Like/News?pageNumber=1&pageSize=10");
    if (res != null) {
      var result = new PagingResult<PostNewsModel>.fromJson(
          res, (v) => new PostNewsModel.fromJson(v));

      return result;
    }
    return null;
  }
}
