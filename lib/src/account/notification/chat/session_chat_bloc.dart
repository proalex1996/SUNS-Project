import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/conversation/dto/conversation_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/conversation/dto/detail_conversation_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/conversation/dto/post_conversation_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class ConversationState {
  List<ConversationModel> get conversations =>
      this.conversationDataSource?.dataSource?.data;
  DataSourceOption<ConversationModel, dynamic> conversationDataSource;

  List<ConversationMessageModel> get conversationMessages =>
      this.conversationMessageDataSource?.dataSource?.data;
  DataSourceOption<ConversationMessageModel, String>
      conversationMessageDataSource;

  ConversationModel conversation;

  ConversationState({
    this.conversation,
    this.conversationDataSource,
    this.conversationMessageDataSource,
  });
}

abstract class ConversationEvent {}

class EventLoadConversation extends ConversationEvent {}

class EventLoadMoreConversation extends ConversationEvent {}

class EventlLoadConversationMessage extends ConversationEvent {
  String conversationId;
  EventlLoadConversationMessage({this.conversationId});
}

class EventlLoadMoreConversationMessage extends ConversationEvent {
  EventlLoadMoreConversationMessage();
}

class EventlAddMoreConversationMessage extends ConversationEvent {
  ConversationMessageModel message;
  EventlAddMoreConversationMessage({this.message});
}

class EventCreateConversationMessage extends ConversationEvent {
  CreateConversationMessageInput model;
  EventCreateConversationMessage({this.model});
}

class EventCreateConversation extends ConversationEvent {
  CreateConversationInput model;
  EventCreateConversation({this.model});
}

class ConversationBloc extends BlocBase<ConversationEvent, ConversationState> {
  static final ConversationBloc _singleton = ConversationBloc._internal();

  factory ConversationBloc() {
    return _singleton;
  }

  ConversationBloc._internal();
  @override
  void initState() {
    this.state = new ConversationState();
    this.state.conversationDataSource =
        DataSourceOption<ConversationModel, dynamic>(
            getDataSource: (option) => _getConversations(option));

    this.state.conversationMessageDataSource =
        DataSourceOption<ConversationMessageModel, String>(
            getDataSource: (option) => _getConversationMessages(option),
            filterConfig: () => this.state.conversation?.id);

    super.initState();
  }

  @override
  Future<ConversationState> mapEventToState(ConversationEvent event) async {
    if (event is EventLoadConversation) {
      await this.state.conversationDataSource.load();
    } else if (event is EventLoadMoreConversation) {
      await this.state.conversationDataSource.loadMore();
    } else if (event is EventlLoadConversationMessage) {
      await _loadDetailConversation(event.conversationId);
      await this.state.conversationMessageDataSource.load();
    } else if (event is EventlLoadMoreConversationMessage) {
      await this.state.conversationMessageDataSource.loadMore();
    } else if (event is EventlAddMoreConversationMessage) {
      await this.state.conversationMessageDataSource.load();
    } else if (event is EventCreateConversationMessage) {
      await _createConversationMessage(event.model);
      await this.state.conversationMessageDataSource.load();
    } else if (event is EventCreateConversation) {
      await _createConversation(event.model);
    }

    return this.state;
  }

  Future<PagingResult<ConversationModel>> _getConversations(
      MappingLoadOptions option) async {
    final service = ServiceProxy();
    var result = await service.conversationServiceProxy.getConversation(
      option.pageNumber,
      option.pageSize,
    );

    if (result?.data?.isNotEmpty == true) {
      var query = result.data.where((e) => e.type != 1 && e.receiverId > 0);
      var receiverIds = query.map((e) => e.receiverId).toSet().toList();

      if (receiverIds.length > 0) {
        var receiverInfos =
            await service.userService.getUserRating(receiverIds);

        query.forEach((item) {
          var receiverInfo = receiverInfos.firstWhere(
              (e) => e.id == item.receiverId.toString(),
              orElse: () => null);
          item.name = receiverInfo.fullName;
          item.image = receiverInfo.avatar;
        });
      }
    }

    return result;
  }

  Future _createConversation(CreateConversationInput model) async {
    final service = ServiceProxy();
    var conversationId =
        await service.conversationServiceProxy.createConversation(model);
    await _loadDetailConversation(conversationId);
    await this.state.conversationMessageDataSource.load();
  }

  Future _loadDetailConversation(String conversationId) async {
    this.state.conversation = this
        .state
        .conversations
        ?.firstWhere((e) => e.id == conversationId, orElse: () => null);

    if (this.state.conversation == null) {
      var service = ServiceProxy();
      this.state.conversation = await service.conversationServiceProxy
          .getConversationDetail(conversationId);
      if (this.state.conversation.type != 1 &&
          this.state.conversation.receiverId > 0) {
        var receiverInfos = await service.userService
            .getUserRating([this.state.conversation.receiverId]);

        if (receiverInfos?.isNotEmpty == true) {
          var receiverInfo = receiverInfos[0];
          this.state.conversation.name = receiverInfo.fullName;
          this.state.conversation.image = receiverInfo.avatar;
        }
      }
    }
  }

  Future<PagingResult<ConversationMessageModel>> _getConversationMessages(
      MappingLoadOptions<String> option) async {
    final service = ServiceProxy();
    var result = await service.conversationServiceProxy.getConversationMessage(
      option.filter,
      option.pageNumber,
      option.pageSize,
    );

    if (result?.data?.isNotEmpty == true) {
      var query = result.data;
      var receiverIds = query.map((e) => e.senderId).toSet().toList();

      if (receiverIds.length > 0) {
        var receiverInfos =
            await service.userService.getUserRating(receiverIds);

        query.forEach((item) {
          var receiverInfo = receiverInfos.firstWhere(
              (e) => e.id == item.senderId.toString(),
              orElse: () => null);
          item.name = receiverInfo.fullName;
          item.image = receiverInfo.avatar;
        });
      }
    }

    return result;
  }

  Future _createConversationMessage(
      CreateConversationMessageInput model) async {
    final service = ServiceProxy();
    var messageId = await service.conversationServiceProxy
        .createConversationMessage(this.state.conversation.id, model);
    var message =
        await service.conversationMessageSeviceProxy.getDetail(messageId);
    this.state.conversation.latestContent = message.content;
    this.state.conversation.latestTime = message.createdTime;
    // var user = SessionBloc().state.user;
    // message.image = user.avatar;
    // message.name = user.fullName;

    // if (this.state.conversationMessageDataSource.option.filter == id) {
    //   if (this.state.conversationMessageDataSource.dataSource == null) {
    //     this.state.conversationMessageDataSource.dataSource =
    //         PagingResult<ConversationMessageModel>();
    //   }

    //   if (this.state.conversationMessageDataSource.dataSource.data == null) {
    //     this.state.conversationMessageDataSource.dataSource.data =
    //         List<ConversationMessageModel>();
    //   }

    //   this
    //       .state
    //       .conversationMessageDataSource
    //       .dataSource
    //       .data
    //       .insert(0, message);
    // }
  }

  /*
  Future _addMoreConversationMessage(
      String id, ConversationMessageModel model) async {
    var user = SessionBloc().state.user;

    if (model.senderId.toString() == user.id) {
      model.image = user.avatar;
      model.name = user.fullName;
    } else {
      final service = ServiceProxy();
      var receiverInfos =
          await service.userService.getUserRating([model.senderId]);

      if (receiverInfos?.isNotEmpty == true) {
        var receiverInfo = receiverInfos[0];
        model.name = receiverInfo.fullName;
        model.image = receiverInfo.avatar;
      }
    }

    if (this.state.conversationMessageDataSource.option.filter == id) {
      if (this.state.conversationMessageDataSource.dataSource == null) {
        this.state.conversationMessageDataSource.dataSource =
            PagingResult<ConversationMessageModel>();
      }

      if (this.state.conversationMessageDataSource.dataSource.data == null) {
        this.state.conversationMessageDataSource.dataSource.data =
            List<ConversationMessageModel>();
      }

      if (!this
          .state
          .conversationMessageDataSource
          .dataSource
          .data
          .any((e) => e.id == model.id)) {
        this
            .state
            .conversationMessageDataSource
            .dataSource
            .data
            .insert(0, model);
      }
    }
  }
  */
}
