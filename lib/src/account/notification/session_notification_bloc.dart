import 'dart:convert';

import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/notification/dto/detail_notification.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/notification/dto/notify_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

import 'package:suns_med/shared/service_proxy/service_proxy.dart';

class NotificationState {
  List<NotifyModel> notify;
  PagingResult<NotifyModel> pagingNotify;
  bool isRead;
  int countNotify;
  NotificationAppointmentRejectData notificationAppointmentRejectData;
  NotificationAppointmentRemindData notificationAppointmentRemindData;
  DetailNotificationModel detailNotification;
  NotificationState(
      {this.notify, this.countNotify, this.isRead, this.detailNotification});
}

abstract class NotificationEvent {}

class LoadGeneralEvent extends NotificationEvent {}

class CountNotifyEvent extends NotificationEvent {}

class EventLoadMoreNotify extends NotificationEvent {}

class MarkReadNotifyEvent extends NotificationEvent {
  String id;
  MarkReadNotifyEvent({this.id});
}

class EventLoadNotificationDetail extends NotificationEvent {
  String notificationId;
  EventLoadNotificationDetail({this.notificationId});
}

class NotificationBloc extends BlocBase<NotificationEvent, NotificationState> {
  static final NotificationBloc _singleton = NotificationBloc._internal();

  factory NotificationBloc() {
    return _singleton;
  }

  NotificationBloc._internal();
  @override
  void initState() {
    this.state = new NotificationState();
    this.state.pagingNotify = PagingResult<NotifyModel>();
    super.initState();
  }

  @override
  Future<NotificationState> mapEventToState(NotificationEvent event) async {
    if (event is LoadGeneralEvent) {
      await _getGeneral();
    } else if (event is CountNotifyEvent) {
      await _getTotalUnread();
    } else if (event is MarkReadNotifyEvent) {
      await _markReadNotify(event.id);
    } else if (event is EventLoadMoreNotify) {
      var current = this.state.pagingNotify;
      await _addMoreDataN(current);
    } else if (event is EventLoadNotificationDetail) {
      await _getDetailNotification(event.notificationId);
    }
    return this.state;
  }

  Future _getGeneral() async {
    var current = this.state.pagingNotify;
    if (current == null) {
      current = PagingResult<NotifyModel>();
      this.state.pagingNotify = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    final service = ServiceProxy().notificationServiceProxy;
    var res =
        await service.getNotify(current.pageNumber = 1, current.pageSize = 10);
    this.state.pagingNotify = res;

    var reject = res?.data?.firstWhere(
        (element) =>
            element.dataExtensionType == "NotificationAppointmentRejectData",
        orElse: () => null);
    if (reject != null) {
      var dataReject = jsonDecode(reject.dataExtension);
      this.state.notificationAppointmentRejectData =
          NotificationAppointmentRejectData.fromJson(dataReject);
    }

    var remind = res?.data?.firstWhere(
        (e) => e.dataExtensionType == "NotificationAppointmentRemindData",
        orElse: () => null);
    if (remind != null) {
      var dataRemind = jsonDecode(remind.dataExtension);
      this.state.notificationAppointmentRemindData =
          NotificationAppointmentRemindData.fromJson(dataRemind);
    }

    // this.state.countNotify = this.state.notify.length;
  }

  Future _addMoreDataN(PagingResult<NotifyModel> model) async {
    final service = ServiceProxy().notificationServiceProxy;
    var result = await service.getNotify(++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
    } else if (result != null) {
      model.data.addAll(result.data);
    }
    var reject = result?.data?.firstWhere(
        (element) =>
            element.dataExtensionType == "NotificationAppointmentRejectData",
        orElse: () => null);
    if (reject != null) {
      var dataReject = jsonDecode(reject.dataExtension);
      this.state.notificationAppointmentRejectData =
          NotificationAppointmentRejectData.fromJson(dataReject);
    }

    var remind = result?.data?.firstWhere(
        (e) => e.dataExtensionType == "NotificationAppointmentRemindData",
        orElse: () => null);
    if (remind != null) {
      var dataRemind = jsonDecode(remind.dataExtension);
      this.state.notificationAppointmentRemindData =
          NotificationAppointmentRemindData.fromJson(dataRemind);
    }
  }

  // Future _getUnreadNotify() async {
  //   final service = ServiceProxy().managementCommonService;
  //   this.state.countNotify = await service.getUnReadNotify();
  // }

  Future _getTotalUnread() async {
    final service = ServiceProxy().notificationServiceProxy;
    this.state.countNotify = await service.getTotalUnread();
  }

  Future _markReadNotify(String id) async {
    final service = ServiceProxy().notificationServiceProxy;
    this.state.isRead = await service.markReadNotify(id);
    if (this.state.isRead == true) {
      var res = await service.getNotify(1, 10);
      this.state.pagingNotify = res;
    }
  }

  Future _getDetailNotification(String notificationId) async {
    final services = ServiceProxy().notificationServiceProxy;
    var res = await services.getDetailNotification(notificationId);
    if (res != null && res.isRead == false) {
      await _markReadNotify(res.id);
    }
    this.state.detailNotification = res;
  }
}
