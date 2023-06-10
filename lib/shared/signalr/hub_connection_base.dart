

import 'dart:async';
import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:suns_med/shared/auth/app_auth_service.dart';
import 'package:suns_med/shared/app_config.dart';

abstract class HubConnectionBase {
  HubConnection _connection;

  HubConnectionBase() {
    this.init();
  }

  @protected
  void init() {
    var url = this.getUrl();
    if (url != null && url.isNotEmpty) {
      var appAuthService = AppAuthService();

      _connection = HubConnectionBuilder()
          .withUrl(
            url,
            HttpConnectionOptions(
              logging: (level, message) => print(message),
              transport: HttpTransportType.webSockets,
              accessTokenFactory: () async {
                return await appAuthService.getToken();
              },
            ),
          )
          .withAutomaticReconnect()
          .build();

      _connection.onclose((exception) async {
        var rd = Random();
        await Future.delayed(Duration(milliseconds: rd.nextInt(5) * 1000));
        await _connection.start();
      });
    }
  }

  @protected
  String getUrl() {
    var messengerBaseUrl = AppConfig().messengerBaseUrl;

    if (messengerBaseUrl != null && messengerBaseUrl.isNotEmpty) {
      messengerBaseUrl = Uri.parse(messengerBaseUrl).origin;

      return '$messengerBaseUrl/hubs/ChatHub';
    }

    return null;
  }

  bool firstRefresh = false;
  Future<void> refresh() async {
    if (!firstRefresh) {
      firstRefresh = true;
      await this._connection.start();
    }
  }

  onListen(String methodName, MethodInvacationFunc newMethod) {
    _connection?.on(methodName, newMethod);
  }

  Future<dynamic> invoke(String methodName, {List<dynamic> args}) async {
    if (this._connection.state != HubConnectionState.connected) {
      await this.refresh();
    }

    return this._connection?.invoke(methodName, args: args);
  }
}
