import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal/common/dto/banner_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/create_post_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/news_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/tabbar_news_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class NewsServiceProxy {
  HttpClient client;
  AppAuthService appAuthService;

  NewsServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) {
    this.client = HttpClient(
      baseUrl: baseUrl,
      prefix: "/api/v1/News",
      appAuthService: appAuthService,
    );
  }

  Future<List<BannerModel>> getAllBanner() async {
    var res = await client.get("/get-img-banner");
    var data = new List<BannerModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new BannerModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<NewsModel>> getAllNews(int id, int pageNo, int pageSize) async {
    var res = await client.get(
        "/get-news-by-menu?menu_id=$id&page_no=$pageNo&page_size=$pageSize");
    var data = new List<NewsModel>();
    for (int i = 1; i < 10; i++) {}

    if (res != null) {
      res.forEach((v) {
        data.add(new NewsModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<MenuNewsModel>> getMenuNews() async {
    var res = await client.get("/get-menu-list");
    var data = new List<MenuNewsModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new MenuNewsModel.fromJson(v));
      });
    }

    return data;
  }

  Future<List<NewsModel>> getNewsLike(String user) async {
    var res = await client
        .get("/get-news-like-by-user?user_name=$user&page_no=1&page_size=2");
    var data = new List<NewsModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new NewsModel.fromJson(v));
      });
    }

    return data;
  }

  Future createPost(CreatePostModel createPostModel) async {
    print(jsonEncode(createPostModel.toJson()));
    await client.post("/post-news", jsonEncode(createPostModel.toJson()));
  }

  Future viewNews(NewsModel newsModel, int id, String userName) async {
    await client.put(
        "view-news?news_id=$id&user_name=$userName", jsonEncode(newsModel));
  }

  Future<List<NewsModel>> searchNews(String key) async {
    var res = await client.get("/search?keyword=$key&page_no=1&page_size=2");

    var data = new List<NewsModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new NewsModel.fromJson(v));
      });
    }

    return data;
  }
}
