import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/suns_api_portal/message/dto/init-chat-model.dart';
import 'package:suns_med/src/Widgets/chat/screens/inbox/chat_bubble.dart';
import 'package:suns_med/src/Widgets/chat/screens/inbox/no_glow_list.dart';
import 'package:suns_med/src/Widgets/chat/screens/inbox/session_message_bloc.dart';
// import 'package:suns_med/src/init_hub-signalr.dart';

class Inbox extends StatefulWidget {
  Inbox({Key key, this.title, this.staffUserId}) : super(key: key);

  final String title;
  final int staffUserId;

  @override
  _InboxState createState() => new _InboxState();
}

class _InboxState extends State<Inbox> {
  // List<ChatMessageModel> messages = [];
  PagingResult<InitChatModel> messages;
  final bloc = SessionBloc();
  final chatBloc = MessageBloc();
  final textEditingController = TextEditingController();
  final _scrollController = ScrollController();

  _onReceiver() {
    // SignalRHubConnection().onListen('ReceiveMessage', (message) {
    //   if (message.length == 3) {
    //     InitChatModel chatMessageModel = InitChatModel();
    //     var senderId = message[0];
    //     var receiverId = message[1];
    //     var content = message[2];
    //     chatMessageModel.content = content.toString();
    //     chatMessageModel.senderId = senderId;
    //     chatMessageModel.createdTime = DateTime.now();
    //     chatBloc
    //         .dispatch(LoadMessageEvent(receiverId: widget?.staffUserId ?? 0));
    //   }

    //   print(message.toString());
    // });
  }

  @override
  void initState() {
    chatBloc.dispatch(LoadMessageEvent(receiverId: widget.staffUserId));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        chatBloc.dispatch(LoadMoreChatEvent(receiverId: widget.staffUserId));
      }
    });

    // this.messages.add(new ChatMessageModel(
    //     message: "ABC",
    //     dateTime: DateTime.now().toIso8601String(),
    //     from: bloc.state.user.id));

    _onReceiver();
    super.initState();
    // initConnection();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.deepBlue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'SA',
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 10,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(widget.title,
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 14)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2),
                child: Icon(
                  EvilIcons.user,
                  color: Colors.white,
                ),
              )
            ],
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Ionicons.ios_videocam,
                    size: 30.0,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    FontAwesome.phone,
                    size: 30.0,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.more_vert,
                  ),
                )),
          ],
        ),
        body: Stack(
          children: <Widget>[
            BlocProvider<MessageEvent, MessageState, MessageBloc>(
                bloc: chatBloc,
                builder: (state) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 70),
                    child: NoGlowList(
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: state.chat?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          var message = state.chat?.data[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ChatBubble(message,
                                fromMe: message.senderId ==
                                    int.parse(bloc.state.user.id)),
                          );
                        },
                      ),
                    ),
                  );
                }),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(
                                fontFamily: 'Montserrat-M',
                                color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (textEditingController.text.isNotEmpty) {
                          // SignalRHubConnection().invoke("SendMessage", args: [
                          //   widget.staffUserId,
                          //   textEditingController.text
                          // ]);
                          chatBloc.dispatch(
                              LoadMessageEvent(receiverId: widget.staffUserId));
                          setState(() {
                            textEditingController.text = "";
                          });
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
