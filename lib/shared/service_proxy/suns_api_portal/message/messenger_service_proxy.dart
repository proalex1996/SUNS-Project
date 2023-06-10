import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/suns_api_portal/message/dto/init-chat-model.dart';

class MessageServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  MessageServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1");

  Future<PagingResult<InitChatModel>> getChatList(
      int receiverId, int pageNum, int pageSize) async {
    var res = await client.get(
        "/Message?receiverId=$receiverId&pageNumber=$pageNum&pageSize=$pageSize");
    if (res != null) {
      var result = PagingResult<InitChatModel>.fromJson(
          res, (v) => new InitChatModel.fromJson(v));
      print(result.data);

      return result;
    }

    return null;
  }
}
