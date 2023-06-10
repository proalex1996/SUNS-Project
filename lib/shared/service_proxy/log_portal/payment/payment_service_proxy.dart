import 'package:flutter/material.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/service_proxy/http_client.dart';
import 'package:suns_med/shared/service_proxy/log_portal/payment/dto/user_wallet_model.dart';
import 'package:suns_med/shared/service_proxy/log_portal/payment/dto/wallet_history_model.dart';

class PaymentServiceProxy {
  HttpClient client;
  AppAuthService appAuthService;

  PaymentServiceProxy({
    @required String baseUrl,
    @required this.appAuthService,
  }) {
    this.client = HttpClient(
      baseUrl: baseUrl,
      prefix: "/api/Payment",
      appAuthService: appAuthService,
    );
  }

  Future<List<WalletHistoryModel>> getWalletHistory() async {
    var res = await client.get("/get-wallet-history");
    var data = new List<WalletHistoryModel>();

    if (res != null) {
      res.forEach((v) {
        data.add(new WalletHistoryModel.fromJson(v));
      });
    }

    return data;
  }

  Future<UserWalletMode> getUserWallet() async {
    var res = await client.get("/GetUserWallet");
    var data = UserWalletMode.fromJson(res);

    return data;
  }

}
