import 'package:flutter/material.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/dialog/msg_dialog.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/account/notification/chat/detail_chat.dart';
import 'package:suns_med/src/product/session_service_user_support_bloc.dart';

class SupportChatAdmin extends StatefulWidget {
  @override
  _SupportChatAdminState createState() => _SupportChatAdminState();
}

class _SupportChatAdminState extends State<SupportChatAdmin> {
  final sessionBloc = SessionBloc();
  final userSupportBloc = UserSupportBloc();

  @override
  void initState() {
    sessionBloc.dispatch(EventGetUser());

    userSupportBloc.dispatch(EventLoadUserSupport());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserSupportEvent, UserSupportState, UserSupportBloc>(
      bloc: userSupportBloc,
      builder: (state) {
        if (userSupportBloc.state.userSupportModel != null &&
            userSupportBloc?.state?.userSupportModel?.id !=
                sessionBloc?.state?.user?.id)
          return DetailChat(
            //chatId: "2ffb6006-7b3d-46fb-975a-0cbb9a7582c7",
            name: userSupportBloc?.state?.userSupportModel?.name ?? '',
            //image: null,
            userId: userSupportBloc?.state?.userSupportModel?.id,
          );
        else {
          return Scaffold(
            backgroundColor: AppColor.whitetwo,
            appBar: AppBar(
              backgroundColor: AppColor.deepBlue,
              title: Text(
                "Chat với Admin",
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: MediaQuery.of(context).size.height * 18 / 812,
                    color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Text(
                'Chức năng tạm đóng',
                style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 18),
              ),
            ),
          );
        }
      },
    );
  }
}
