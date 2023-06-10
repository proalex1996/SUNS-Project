import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/notification/dto/detail_notification.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/notification/dto/notify_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class NotificationServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  NotificationServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1/Notification");

  Future<int> getTotalUnread() async {
    var data = await client.get("/TotalUnread");

    return data;
  }

  Future<PagingResult<NotifyModel>> getNotify(int pageNum, int pageSize) async {
    var res = await client.get("?pageNumber=$pageNum&pageSize=$pageSize");

    if (res != null) {
      var data = PagingResult<NotifyModel>.fromJson(
          res, (v) => new NotifyModel.fromJson(v));

      return data;
    }
    return null;
  }

  Future<bool> markReadNotify(String id) async {
    var res = await client.post("/$id/MarkRead", jsonEncode(null));
    return res;
  }

  Future<DetailNotificationModel> getDetailNotification(
      String notificationId) async {
    var res = await client.get("/$notificationId");
    var data = new DetailNotificationModel.fromJson(res);
    return data;
  }
}
