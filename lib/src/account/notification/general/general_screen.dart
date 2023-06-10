import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/app_config.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/notification_item.dart';
import 'package:suns_med/src/account/notification/general/notificationdetail_screen.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';

class GeneralScreen extends StatefulWidget {
  @override
  _GeneralScreenState createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  final bloc = NotificationBloc();
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  @override
  initState() {
    bloc.dispatch(LoadGeneralEvent());
    setState(() {
      isLoading = true;
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.dispatch(EventLoadMoreNotify());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? _getGeneral() : AppConfig().loading,
    );
  }

  _getGeneral() {
    return BlocProvider<NotificationEvent, NotificationState, NotificationBloc>(
      bloc: bloc,
      builder: (output) {
        return output.pagingNotify.data != null
            ? (output.pagingNotify.data.length == 0
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: Text(
                      "Không có thông báo mới",
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 20,
                          color: AppColor.darkPurple.withOpacity(0.8)),
                    ),
                  ))
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Wrap(
                      children: List.generate(
                        output.pagingNotify?.data?.length,
                        (index) {
                          var notify = output.pagingNotify?.data[index];
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: NotificationItem(
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotifyDetailScreen(
                                      notifyModel: notify,
                                      notificationAppointmentRejectData: output
                                          .notificationAppointmentRejectData,
                                      notificationAppointmentRemindData: output
                                          .notificationAppointmentRemindData,
                                    ),
                                  ),
                                );
                              },
                              isRead: notify?.isRead,
                              title: notify?.title,
                              subTitle: notify?.message,
                              createOn: notify?.createdTime?.toIso8601String(),
                            ),
                          );
                        },
                      ),
                    ),
                  ))
            : AppConfig().loading;
      },
    );
  }
}
