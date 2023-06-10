import 'package:flutter/material.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';

class NewsCommentServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  NewsCommentServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1");

  Future<bool> deleteComment(String commentId) async {
    var res = await client.delete("/NewsComment/$commentId");
    return res;
  }
}
