// import 'package:flutter/material.dart';
// import 'package:suns_med/common/theme/theme_color.dart';
// import 'package:suns_med/src/Widgets/chat.dart';
// import 'package:suns_med/src/account/chat/chat_model.dart';

// class ListChatScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.deepBlue,
//         title: Text(
//           'Chat',
//           style:TextStyle(
//           fontFamily: 'Montserrat-M',fontSize: 18, color: AppColor.whitethree),
//         ),
//         centerTitle: true,
//         actions: <Widget>[
//           IconButton(icon: Icon(Icons.search), onPressed: () {})
//         ],
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//               child: ListView.builder(
//                   itemCount: chats.length,
//                   itemBuilder: (ctx, index) {
//                     return ChatItem(
//                       img: chats[index].img,
//                       name: chats[index].name,
//                       text: chats[index].text,
//                       time: chats[index].time,
//                       textnotifi: chats[index].textnotifi,
//                     );
//                   }))
//         ],
//       ),
//     );
//   }
// }
