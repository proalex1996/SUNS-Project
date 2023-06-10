import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/category/dto/category_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/category/dto/input_post_model.dart';

class CategoryServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  CategoryServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(appAuthService: appAuthService, baseUrl: baseUrl);

  Future<List<CategoryModel>> getCategory() async {
    var res = await client.get('/Category');
    var data = new List<CategoryModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new CategoryModel.fromJson(v));
      });
    }
    return data;
  }

  Future createPost(InputPostModel inputPostModel, int categoryId) async {
    print(jsonEncode(inputPostModel.toJson()));
    await client.post(
        "/Category/$categoryId/News", jsonEncode(inputPostModel.toJson()));
  }
}
