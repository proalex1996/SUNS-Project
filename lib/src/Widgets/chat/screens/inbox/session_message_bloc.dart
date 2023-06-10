import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/suns_api_portal/message/dto/init-chat-model.dart';

class MessageState {
  PagingResult<InitChatModel> chat;
  MessageState({this.chat});
}

abstract class MessageEvent {}

class LoadMessageEvent extends MessageEvent {
  int receiverId;
  LoadMessageEvent({this.receiverId});
}

class LoadMoreChatEvent extends MessageEvent {
  int receiverId;
  LoadMoreChatEvent({this.receiverId});
}

class MessageBloc extends BlocBase<MessageEvent, MessageState> {
  @override
  void initState() {
    this.useGlobalLoading = false;
    this.state = new MessageState();
    super.initState();
  }

  @override
  Future<MessageState> mapEventToState(MessageEvent event) async {
    if (event is LoadMessageEvent) {
      await _getChatList(event.receiverId);
    } else if (event is LoadMoreChatEvent) {
      var current = this.state.chat;
      await _addMoreChat(current, event.receiverId);
    }
    return this.state;
  }

  Future _getChatList(int receiverId) async {
    final service = ServiceProxy();
    var current = this.state.chat;
    if (current == null) {
      current = PagingResult<InitChatModel>();
      this.state.chat = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }

    var res = await service.messageServiceProxy
        .getChatList(receiverId, current.pageNumber = 1, current.pageSize = 10);
    this.state.chat = res;
  }

  Future _addMoreChat(PagingResult<InitChatModel> model, int receiverId) async {
    final service = ServiceProxy().messageServiceProxy;
    var result = await service.getChatList(
        receiverId, ++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
    } else if (result != null) {
      model.data.addAll(result.data);
    }
  }
}
