import 'package:flutter/material.dart';
import 'package:suns_med/shared/service_proxy/suns_api_portal/message/dto/init-chat-model.dart';

class ChatBubble extends StatefulWidget {
  final InitChatModel chatMessageModel;
  final bool fromMe;

  ChatBubble(this.chatMessageModel, {this.fromMe = false});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final borderRadius = 10.0;
    var e = widget.chatMessageModel;
    var fromMe = widget.fromMe;
    return Container(
      margin: EdgeInsets.only(left: !fromMe ? 10 : 0, right: fromMe ? 10 : 0),
      alignment: widget.fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: widget.fromMe ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(fromMe ? 0 : borderRadius),
              bottomRight: Radius.circular(borderRadius),
              topLeft: Radius.circular(!fromMe ? 0 : borderRadius),
              bottomLeft: Radius.circular(borderRadius),
            )),
        child: Column(
          crossAxisAlignment:
              widget.fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Text(
            //   e.dateTime,
            //   style:TextStyle(
            //                          fontFamily: 'Montserrat-M',
            //     fontSize: 12,
            //     fontStyle: FontStyle.italic,
            //     color: fromMe ? WHITE : GREEN,
            //   ),
            // ),
            Text(
              e.content,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 18,
                  color: fromMe ? Colors.white : Colors.black,
                  letterSpacing: 1.1),
            ),
          ],
        ),
      ),
    );
  }
}
