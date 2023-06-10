import 'dart:core';
import 'package:suns_med/shared/signalr/hub_connection_base.dart';

class ChatHubConnection extends HubConnectionBase {
  static final ChatHubConnection _instance = ChatHubConnection._internal();
  ChatHubConnection._internal();

  factory ChatHubConnection() {
    return _instance;
  }

  String conversationActiveId;
  
  void onReceiveConversationMessage(
      Function(String conversationId, String data) callback) {
    this.onListen("ReceiveConversationMessage", (arguments) {
      if (arguments.length == 2) {
        String conversationId = arguments[0];
        String data = arguments[1];
        callback?.call(conversationId, data);
      }
    });
  }
}
