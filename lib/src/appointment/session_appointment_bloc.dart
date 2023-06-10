import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/appointment_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/cancel_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/detail_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/exam_service_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/input_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/input_ordinalnumber_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/dto/order_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/service_package/dto/detail_service_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';

class AppointmentState {
  List<AppointmentNewsModel> appointmentNews;
  Map<int, PagingResult<AppointmentNewsModel>> pagingAppointment;
  PagingResult<ExamServicesModel> examService;
  List<RelationshipModel> relationship;
  List<ContactModel> contact;
  ContactModel contactModel;
  DetailAppointmentModel detailAppointment;
  DetailServiceModel detailService;
  OrderModelNew order;
  bool cancelAppointment;
  bool allowedAcceptRequestReject;

  AppointmentState(
      {this.appointmentNews,
      this.relationship,
      this.contact,
      this.order,
      this.detailAppointment,
      this.detailService,
      this.contactModel,
      this.cancelAppointment,
      this.allowedAcceptRequestReject});
}

abstract class AppointmentEvent {}

class EventLoadMoreAppointment extends AppointmentEvent {
  String userName;
  AppointmentFilterQuery filterQuery;
  int type;
  EventLoadMoreAppointment({this.userName, this.filterQuery, this.type});
}

class EventLoadAppointment extends AppointmentEvent {
  AppointmentFilterQuery filterQuery;
  int type;
  EventLoadAppointment({this.filterQuery, this.type});
}

class LoadRelationshipEvent extends AppointmentEvent {}

class LoadContactEvent extends AppointmentEvent {}

class LoadDetailAppointmentvent extends AppointmentEvent {
  String id;
  LoadDetailAppointmentvent({this.id});
}

class EventLoadExamServices extends AppointmentEvent {
  String id;
  EventLoadExamServices({this.id});
}

class EventAddMoreExamServices extends AppointmentEvent {
  String id;
  EventAddMoreExamServices({this.id});
}

class EventInputOrdinalNumber extends AppointmentEvent {
  InputPrintOrdinalNumberModel printOrdinalNumberModel;

  EventInputOrdinalNumber({this.printOrdinalNumberModel});
}

class ResetStateAppointmentEvent extends AppointmentEvent {}

class EventCancelAppointment extends AppointmentEvent {
  String appointmentId;
  CancelAppointmentModel cancelAppointment;

  EventCancelAppointment({
    this.appointmentId,
    this.cancelAppointment,
  });
}

class AllowAcceptRequestRejectEvent extends AppointmentEvent {
  String id;
  AllowAcceptRequestRejectEvent({this.id});
}

class AcceptRequestRejectEvent extends AppointmentEvent {
  String id;
  AcceptRequestRejectEvent({this.id});
}

class AppointmentBloc extends BlocBase<AppointmentEvent, AppointmentState> {
  static final AppointmentBloc _instance = AppointmentBloc._internal();
  AppointmentBloc._internal();

  factory AppointmentBloc() {
    return _instance;
  }

  CancelAppointmentModel cancelAppointment = CancelAppointmentModel();

  @override
  void initState() {
    // this.useGlobalLoading = false;
    this.state = new AppointmentState();
    this.state.pagingAppointment =
        Map<int, PagingResult<AppointmentNewsModel>>();
    this.state.examService = PagingResult<ExamServicesModel>();
    super.initState();
  }

  @override
  Future<AppointmentState> mapEventToState(AppointmentEvent event) async {
    if (event is EventLoadMoreAppointment) {
      // await _loaAppointment(event.userName);
      var current = this.state.pagingAppointment[event.type];
      await _addMoreDataN(current, event.filterQuery);
      // this.state.appointmentNews = current.data;
    } else if (event is EventLoadAppointment) {
      await _loadAppointmentNews(event.filterQuery, event.type);
      await _loadContact();
      await _loadRelationship();
    } else if (event is LoadRelationshipEvent) {
      await _loadRelationship();
    } else if (event is LoadContactEvent) {
      await _loadContact();
    } else if (event is LoadDetailAppointmentvent) {
      await loadDetailAppointment(event.id);
    } else if (event is EventInputOrdinalNumber) {
      await _inputOrdinalNum(event.printOrdinalNumberModel);
    } else if (event is EventLoadExamServices) {
      await _getExamServices(event.id);
    } else if (event is EventAddMoreExamServices) {
      var current = this.state.examService;
      await _addMoreExamServices(current, event.id);
    } else if (event is ResetStateAppointmentEvent) {
      this.state.pagingAppointment = null;
    } else if (event is EventCancelAppointment) {
      await _cancelAppointment(event.appointmentId, event.cancelAppointment);
      await loadDetailAppointment(event.appointmentId);

      // await _getListAppointment(event.companyId, event.filterQuery);
    } else if (event is AllowAcceptRequestRejectEvent) {
      await _getAllowAcceptRequestReject(event.id);
    } else if (event is AcceptRequestRejectEvent) {
      await _postAcceptRequestReject(event.id);
    }

    return this.state;
  }

  Future _loadAppointmentNews(
      AppointmentFilterQuery filterQuery, int type) async {
    var current = this.state.pagingAppointment[type];
    if (current == null) {
      current = PagingResult<AppointmentNewsModel>();
      this.state.pagingAppointment[type] = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    final service = ServiceProxy().appointmentServiceProxy;
    var res = await service.getAppointmentNews(
        current.pageNumber = 1, current.pageSize = 10, filterQuery);
    // this.state.appointmentNews = res?.data;
    this.state.pagingAppointment[type] = res;
  }

  Future _addMoreDataN(PagingResult<AppointmentNewsModel> model,
      AppointmentFilterQuery filterQuery) async {
    final service = ServiceProxy().appointmentServiceProxy;
    var result = await service.getAppointmentNews(
        ++model.pageNumber, model.pageSize, filterQuery);
    if (model.data == null) {
      model.data = result.data;
    } else if (result != null) {
      model.data.addAll(result.data);
    }
  }

  Future _loadRelationship() async {
    final service = ServiceProxy().commonService;
    this.state.relationship = await service.getAllRelationship();
  }

  Future _loadContact() async {
    final service = ServiceProxy().userService;
    this.state.contact = await service.getContacts();
  }

  Future loadDetailAppointment(String id) async {
    final service = ServiceProxy();
    this.state.detailAppointment =
        await service.appointmentServiceProxy.getDetailAppointment(id);
    if (this.state.detailAppointment != null &&
        this.state.detailAppointment.orderId != null) {
      this.state.order = await service.orderServiceProxy
          .getOder(this.state.detailAppointment.orderId);
    }
    if (this.state.detailAppointment != null &&
        this.state.detailAppointment.servicePackageId != null) {
      this.state.detailService = await service.packageServiceProxy
          .getDetailService(this.state.detailAppointment.servicePackageId);
    }
  }

  Future _inputOrdinalNum(
      InputPrintOrdinalNumberModel printOrdinalNumberModel) async {
    final service = ServiceProxy();
    var res = await service.newCommonServiceProxy
        .inputOrdinalNumber(printOrdinalNumberModel);
    print(res);
  }

  Future _getExamServices(String serviceId) async {
    var current = this.state.examService;
    if (current == null) {
      current = PagingResult<ExamServicesModel>();
      this.state.examService = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    final service = ServiceProxy().appointmentServiceProxy;
    var res = await service.getExamServices(
        serviceId, current.pageNumber = 1, current.pageSize = 10);
    // this.state.appointmentNews = res?.data;
    this.state.examService = res;
  }

  Future _addMoreExamServices(
      PagingResult<ExamServicesModel> model, String serviceId) async {
    final service = ServiceProxy().appointmentServiceProxy;
    var result = await service.getExamServices(
        serviceId, ++model.pageNumber, model.pageSize);
    if (model.data == null) {
      model.data = result.data;
    } else if (result != null) {
      model.data.addAll(result.data);
    }
  }

  Future _cancelAppointment(String appointmentId,
      CancelAppointmentModel cancelAppointmentModel) async {
    final service = ServiceProxy();
    cancelAppointment = cancelAppointmentModel;
    var res = await service.appointmentServiceProxy
        .cancelAppointment(appointmentId, cancelAppointment);
    this.state.cancelAppointment = res;
  }

  Future _getAllowAcceptRequestReject(String id) async {
    final service = ServiceProxy().appointmentServiceProxy;
    this.state.allowedAcceptRequestReject =
        await service.getAllowAcceptRequestReject(id);
  }

  Future _postAcceptRequestReject(String id) async {
    final service = ServiceProxy().appointmentServiceProxy;
    await service.postAcceptRequestReject(id);
  }
}
