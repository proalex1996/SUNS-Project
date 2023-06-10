import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/conversation/dto/conversation_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/conversation/dto/detail_conversation_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/conversation/dto/post_conversation_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class ConversationSeviceProxy extends EndUserServiceProxyBase {
  ConversationSeviceProxy({
    @required String baseUrl,
    @required AppAuthService appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/Conversation");

  Future<PagingResult<ConversationModel>> getConversation(
      int pageNum, int pageSize) async {
    var res = await client.get("?pageNumber=$pageNum&pageSize=$pageSize");

    if (res != null) {
      var data = PagingResult<ConversationModel>.fromJson(
          res, (v) => new ConversationModel.fromJson(v));

      return data;
    }
    return null;
  }

  
  Future<ConversationModel> getConversationDetail(String id) async {
    var res = await client.get("/$id");

    return res != null ? ConversationModel.fromJson(res) : null;
  }

  Future<String> createConversation(CreateConversationInput model) async {
    var res = await client.post("", jsonEncode(model.toJson()));

    return res;
  }

  Future<PagingResult<ConversationMessageModel>> getConversationMessage(
      String conversationId, int pageNum, int pageSize) async {
    var res = await client
        .get("/$conversationId/Message?pageNumber=$pageNum&pageSize=$pageSize");

    if (res != null) {
      var data = PagingResult<ConversationMessageModel>.fromJson(
          res, (v) => new ConversationMessageModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<String> createConversationMessage(
    String conversationId,
    CreateConversationMessageInput model,
  ) async {
    var res = await client.post(
        "/$conversationId/Message", jsonEncode(model.toJson()));
    var result = res;

    return result;
  }
}

class ConversationMessageSeviceProxy extends EndUserServiceProxyBase {
  ConversationMessageSeviceProxy({
    @required String baseUrl,
    @required AppAuthService appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/ConversationMessage");

  Future<ConversationMessageModel> getDetail(String id) async {
    var res = await client.get("/$id");

    return res != null ? ConversationMessageModel.fromJson(res) : null;
  }
}
