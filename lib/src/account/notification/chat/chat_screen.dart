import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/chat.dart';
import 'package:suns_med/src/account/notification/chat/detail_chat.dart';
import 'package:suns_med/src/account/notification/chat/session_chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final bloc = ConversationBloc();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc.dispatch(EventLoadConversation());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.dispatch(EventLoadMoreConversation());
      }
    });
    
    // ChatHubConnection().conversationActiveId = true;
    // ChatHubConnection().onReceiveConversationMessage((conversationId, data) {
    //   bloc.dispatch(EventLoadConversation());
    // });
  }

  @override
  void deactivate() {
    // ChatHubConnection().active = false;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConversationEvent, ConversationState, ConversationBloc>(
      bloc: bloc,
      builder: (state) {
        return ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            itemCount: state.conversations?.length ?? 0,
            itemBuilder: (ctx, index) {
              var conversation = state.conversations[index];

              return ChatItem(
                img: conversation.image,
                name: conversation.name,
                latestContent: conversation.latestContent,
                latestTime: conversation.latestTime,
                textnotifi: null,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailChat(
                        chatId: conversation.id,
                        name: conversation.name,
                        image: conversation.image,
                        userId: conversation.receiverId?.toString(),
                      ),
                    ),
                  );
                },
              );
            });
      },
    );
  }
}
