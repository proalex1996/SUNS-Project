import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/comment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/postnews_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/result_comment_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/news_model.dart';

class PostNewsServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  PostNewsServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1");

  Future<PagingResult<PostNewsModel>> getPostnews(
      int id, int pageNum, int pageSize) async {
    var res = await client
        .get("/Category/$id/News?pageNumber=$pageNum&pageSize=$pageSize");
    if (res != null) {
      var result = PagingResult<PostNewsModel>.fromJson(
          res, (v) => new PostNewsModel.fromJson(v));

      return result;
    }
    return null;
  }

  Future<PagingResult<PostNewsModel>> getAllNews(
      int pageNum, int pageSize) async {
    var res = await client.get('/News?pageNumber=$pageNum&pageSize=$pageSize');
    if (res != null) {
      var result = new PagingResult<PostNewsModel>.fromJson(res, (v) {
        return new PostNewsModel.fromJson(v);
      });

      return result;
    }
    return null;
  }

  Future<PagingResult<PostNewsModel>> getSearchPost(
      String keyword, int pageNum, int pageSize) async {
    var keyWord = keyword == null || keyword.isEmpty ? "" : "keyword=$keyword&";
    var res = await client
        .get("/News?${keyWord}pageNumber=$pageNum&pageSize=$pageSize");
    if (res != null) {
      var result = PagingResult<PostNewsModel>.fromJson(
          res, (v) => new PostNewsModel.fromJson(v));

      return result;
    }
    return null;
  }

  Future<PagingResult<PostNewsModel>> getSearchPostPopular(
      String keyword, int pageNum, int pageSize) async {
    var keyWord = keyword == null || keyword.isEmpty ? "" : "keyword=$keyword&";
    var res = await client.get(
        "/News?${keyWord}pageNumber=$pageNum&pageSize=$pageSize&featured=true");
    if (res != null) {
      var result = PagingResult<PostNewsModel>.fromJson(
          res, (v) => new PostNewsModel.fromJson(v));

      return result;
    }
    return null;
  }

  Future<bool> getHasLikeOfPost(String id) async {
    var res = await client.get("/News/$id/HasLike");
    return res;
  }

  Future<bool> viewPost(String id) async {
    var res = await client.post("/News/$id/View", jsonEncode(null));
    return res;
  }

  Future<bool> likePost(String id) async {
    var res = await client.post("/News/$id/Like", jsonEncode(null));
    return res;
  }

  Future<bool> unlikePost(String id) async {
    var res = await client.delete("/News/$id/Like");
    return res;
  }

  Future<bool> sharePost(String id) async {
    var res = await client.post("/News/$id/Share", jsonEncode(null));
    return res;
  }

  Future<String> commentPost(String id, CommentModel commentModel) async {
    var res = await client.post("/News/$id/Comment", jsonEncode(commentModel));
    return res;
  }

  Future<PagingResult<ResultCommentModel>> resultComment(
      String id, int pageNumber, int pageSize) async {
    var res = await client
        .get("/News/$id/Comment?pageNumber=$pageNumber&pageSize=$pageSize");
    if (res != null) {
      var data = PagingResult<ResultCommentModel>.fromJson(
          res, (v) => new ResultCommentModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<bool> allowedPost() async {
    var res = await client.get("/News/AllowedPost");
    return res;
  }
}
