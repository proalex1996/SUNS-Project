import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/dto/order_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/dto/post_order_model.dart';

class OrderServiceProxy extends EndUserServiceProxyBase {
  HttpClient client;
  AppAuthService appAuthService;

  OrderServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) : super(
            appAuthService: appAuthService,
            baseUrl: baseUrl,
            prefix: "/api/v1");

  Future<String> postOrderModel(PostOrderModel postOrderModel) async {
    var res = await client.post("/Order", jsonEncode(postOrderModel));
    return res;
  }

  Future<OrderModelNew> getOder(String orderId) async {
    var res = await client.get("/Order/$orderId");
    var data = OrderModelNew.fromJson(res);
    return data;
  }

  Future<bool> postOrderPay(String orderId, int paymentMethod) async {
    var res = await client.post(
        "/Order/$orderId/Pay?paymentMethod=$paymentMethod", null);
    return res;
  }
}
