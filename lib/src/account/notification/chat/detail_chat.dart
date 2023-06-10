import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/chat/chat_hub_connection.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/conversation/dto/post_conversation_model.dart';
import 'package:suns_med/src/account/notification/chat/session_chat_bloc.dart';
import 'package:suns_med/src/Widgets/call/incoming_call.dart';
import 'package:suns_med/shared/call/call_workflow.dart';
import 'package:suns_med/shared/dialog/msg_dialog.dart';

class DetailChat extends StatefulWidget {
  final String chatId;
  final String name;
  final String image;
  final String userId;
  const DetailChat({Key key, this.chatId, this.name, this.image, this.userId})
      : super(key: key);

  @override
  _DetailChatState createState() => _DetailChatState();
}

class _DetailChatState extends State<DetailChat> {
  final bloc = ConversationBloc();
  final textEditingController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  CreateConversationMessageInput postConversationModel =
      CreateConversationMessageInput();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    bloc.state.conversationMessageDataSource?.clear();

    if (!(widget.chatId?.isNotEmpty == true)) {
      var userId = int.parse(widget.userId);

      bloc.stream.listen((data) {
        if (!(widget.chatId?.isNotEmpty == true)) {
          ChatHubConnection().conversationActiveId = data.conversation?.id;
        }
      });

      bloc.dispatch(EventCreateConversation(
          model: CreateConversationInput(userIds: [userId], type: 0)));
    } else {
      bloc.dispatch(
          EventlLoadConversationMessage(conversationId: widget.chatId));
      ChatHubConnection().conversationActiveId = widget.chatId;
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.dispatch(EventlLoadMoreConversationMessage());
      }
    });

    ChatHubConnection().onReceiveConversationMessage((conversationId, data) {
      if (bloc.state.conversation?.id == conversationId) {
        bloc.dispatch(
            EventlLoadConversationMessage(conversationId: conversationId),
            reverseGlobalLoading: true);
      }
    });
  }

  @override
  void deactivate() {
    ChatHubConnection().conversationActiveId = null;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocProvider<ConversationEvent, ConversationState, ConversationBloc>(
        bloc: bloc,
        builder: (state) {
          var receiverId =
              widget.userId ?? state.conversation?.receiverId.toString();
          var name = widget.name ?? state.conversation?.name ?? "";
          var image = widget.image ?? state.conversation?.image;

          return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              backgroundColor: AppColor.purple,
              title: Text(
                name,
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: height * 20 / 812,
                    color: Colors.white),
              ),
              centerTitle: true,
              // actions: <Widget>[
              //   Padding(
              //       padding: EdgeInsets.only(right: 20.0),
              //       child: GestureDetector(
              //         onTap: () {
              //           _navigateInComming(CallInfo(
              //               id: receiverId, name: name, avatar: image));
              //         },
              //         child: Icon(
              //           Icons.videocam_sharp,
              //           size: 30.0,
              //         ),
              //       )),
              // Padding(
              //     padding: EdgeInsets.only(right: 20.0),
              //     child: GestureDetector(
              //       onTap: () {},
              //       child: Icon(
              //         Icons.more_vert,
              //       ),
              //     )),
              // ],
            ),
            body: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 70),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          itemCount: state.conversationMessages?.length ?? 0,
                          itemBuilder: (context, index) {
                            var conversationMessage =
                                state.conversationMessages[index];
                            // var userRatingId = conversation.senderId ?? 0;
                            // var userValue = state?.listUserRating?.any((element) =>
                            //             int.parse(element.id) == userRatingId) ==
                            //         true
                            //     ? state?.listUserRating?.firstWhere(
                            //         (element) => int.parse(element.id) == userRatingId)
                            //     : null;
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: receiverId ==
                                          conversationMessage.senderId
                                              .toString()
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  children: [
                                    receiverId ==
                                            conversationMessage.senderId
                                                .toString()
                                        ? Row(children: [
                                            // _renderImage(image),
                                            SizedBox(
                                              width: width * 10 / 375,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: AppColor.whitetwo,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  padding: EdgeInsets.fromLTRB(
                                                      width * 13 / 375,
                                                      height * 11 / 812,
                                                      width * 13 / 375,
                                                      height * 9 / 812),
                                                  width: width * 231 / 375,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        conversationMessage
                                                                    .content ==
                                                                null
                                                            ? ""
                                                            : conversationMessage
                                                                ?.content,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat-M',
                                                            fontSize: height *
                                                                16 /
                                                                812),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: height * 8 / 812),
                                                Text(
                                                  conversationMessage
                                                              .createdTime ==
                                                          null
                                                      ? ""
                                                      : DateFormat.Hm('vi')
                                                          .format(
                                                              conversationMessage
                                                                  .createdTime),
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-M',
                                                      fontSize:
                                                          height * 12 / 812,
                                                      color: AppColor.warmGrey),
                                                ),
                                              ],
                                            )
                                          ])
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: AppColor.ocenBlue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  padding: EdgeInsets.fromLTRB(
                                                      width * 13 / 375,
                                                      height * 11 / 812,
                                                      width * 13 / 375,
                                                      height * 9 / 812),
                                                  width: width * 231 / 375,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        conversationMessage
                                                                .content ??
                                                            "",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat-M',
                                                            fontSize: height *
                                                                16 /
                                                                812,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: height * 8 / 812),
                                                Text(
                                                  conversationMessage
                                                              .createdTime ==
                                                          null
                                                      ? ""
                                                      : DateFormat.Hm('vi')
                                                          .format(
                                                              conversationMessage
                                                                  .createdTime),
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-M',
                                                      fontSize:
                                                          height * 12 / 812,
                                                      color: AppColor.warmGrey),
                                                ),
                                              ])
                                  ],
                                ),
                                SizedBox(
                                  height: height * 24 / 812,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    height: 60,
                    width: double.infinity,
                    color: AppColor.whitetwo,
                    child: Row(
                      children: <Widget>[
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //     height: 30,
                        //     width: 30,
                        //     decoration: BoxDecoration(
                        //       color: Colors.lightBlue,
                        //       borderRadius: BorderRadius.circular(30),
                        //     ),
                        //     child: Icon(
                        //       Icons.add,
                        //       color: Colors.white,
                        //       size: 20,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: Colors.black54),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Image.asset(
                                  'assets/images/send_button.png',
                                  height: 28,
                                  width: 28,
                                  fit: BoxFit.cover,
                                ),
                                onPressed: () {
                                  if (_textController != null &&
                                      _textController.text.isNotEmpty &&
                                      _checkSpaceSpace(_textController.text) ==
                                          true) {
                                    postConversationModel.content =
                                        _textController.text;
                                    bloc.dispatch(
                                        EventCreateConversationMessage(
                                            model: postConversationModel));

                                    _textController.clear();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 15,
                        // ),
                        // FloatingActionButton(
                        //   onPressed: () {
                        //     if (_textController != null &&
                        //         _textController.text.isNotEmpty &&
                        //         _checkSpaceSpace(_textController.text) == true) {
                        //       postConversationModel.content = _textController.text;
                        //       bloc.dispatch(EventPostConversation(
                        //           conversationId: widget.chatId,
                        //           model: postConversationModel));

                        //       _textController.clear();
                        //     }
                        //   },
                        //   child: Icon(
                        //     Icons.send,
                        //     color: Colors.white,
                        //     size: 18,
                        //   ),
                        //   backgroundColor: Colors.blue,
                        //   elevation: 0,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _renderImage(String image) {
    Widget result;
    var imageDefault = 'assets/images/avatar2.png';
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (image != null && image.isNotEmpty) {
      result = CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          width: width * 45 / 375,
          height: height * 45 / 812,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => CircleAvatar(
          maxRadius: 30,
          backgroundColor: Color(0xffebeaef),
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                    image: AssetImage('assets/images/ic_persondefault.png'))),
          ),
        ),
      );
    } else {
      result = Container(
        child: Image.asset(
          imageDefault,
          width: 40,
          height: 40,
        ),
      );
    }
    return result;
  }

  bool _checkSpaceSpace(String value) {
    Pattern pattern = r'(?=.*?[A-Za-z])';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  _navigateInComming(CallInfo callInfo) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => InCommingCall(
          info: CommingCallInfo(
            isInCommingCall: false,
            receiver: callInfo,
          ),
        ),
      ),
    );
  }
}
