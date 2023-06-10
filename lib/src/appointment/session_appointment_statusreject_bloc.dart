import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/appointment_service_proxy.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/detail_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/exam_service_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/dto/input_appointment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/input_ordinalnumber_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/order/dto/order_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';

class AppointmentRejectState {
  PagingResult<AppointmentNewsModel> pagingAppointmentReject;
  PagingResult<ExamServicesModel> examService;
  List<RelationshipModel> relationship;
  List<ContactModel> contact;
  ContactModel contactModel;
  DetailAppointmentModel detailAppointment;
  OrderModelNew order;

  AppointmentRejectState(
      {this.relationship,
      this.contact,
      this.order,
      this.detailAppointment,
      this.contactModel});
}

abstract class AppointmentRejectEvent {}

class EventLoadMoreAppointmentReject extends AppointmentRejectEvent {
  String userName;
  AppointmentFilterQuery filterQuery;
  EventLoadMoreAppointmentReject({this.userName, this.filterQuery});
}

class EventLoadAppointmentReject extends AppointmentRejectEvent {
  AppointmentFilterQuery filterQuery;
  EventLoadAppointmentReject({this.filterQuery});
}

class LoadRelationshipEvent extends AppointmentRejectEvent {}

class LoadContactEvent extends AppointmentRejectEvent {}

class LoadDetailAppointmenRejecttvent extends AppointmentRejectEvent {
  String id;
  LoadDetailAppointmenRejecttvent({this.id});
}

class EventLoadExamServices extends AppointmentRejectEvent {
  String id;
  EventLoadExamServices({this.id});
}

class EventAddMoreExamServices extends AppointmentRejectEvent {
  String id;
  EventAddMoreExamServices({this.id});
}

class EventInputOrdinalNumberReject extends AppointmentRejectEvent {
  InputPrintOrdinalNumberModel printOrdinalNumberModel;

  EventInputOrdinalNumberReject({this.printOrdinalNumberModel});
}

class AppointmentRejectBloc
    extends BlocBase<AppointmentRejectEvent, AppointmentRejectState> {
  static final AppointmentRejectBloc _instance =
      AppointmentRejectBloc._internal();
  AppointmentRejectBloc._internal();

  factory AppointmentRejectBloc() {
    return _instance;
  }
  @override
  void initState() {
    this.state = new AppointmentRejectState();
    this.state.pagingAppointmentReject = PagingResult<AppointmentNewsModel>();
    this.state.examService = PagingResult<ExamServicesModel>();
    super.initState();
  }

  @override
  Future<AppointmentRejectState> mapEventToState(
      AppointmentRejectEvent event) async {
    if (event is EventLoadMoreAppointmentReject) {
      // await _loaAppointment(event.userName);
      var current = this.state.pagingAppointmentReject;
      await _addMoreDataN(current, event.filterQuery);
      // this.state.appointmentNews = current.data;
    } else if (event is EventLoadAppointmentReject) {
      await _loadAppointmentNews(event.filterQuery);
      await _loadContact();
      await _loadRelationship();
    } else if (event is LoadRelationshipEvent) {
      await _loadRelationship();
    } else if (event is LoadContactEvent) {
      await _loadContact();
    } else if (event is LoadDetailAppointmenRejecttvent) {
      await _loadDetailAppointment(event.id);
    } else if (event is EventInputOrdinalNumberReject) {
      await _inputOrdinalNum(event.printOrdinalNumberModel);
    } else if (event is EventLoadExamServices) {
      await _getExamServices(event.id);
    } else if (event is EventAddMoreExamServices) {
      var current = this.state.examService;
      await _addMoreExamServices(current, event.id);
    }

    return this.state;
  }

  Future _loadAppointmentNews(AppointmentFilterQuery filterQuery) async {
    var current = this.state.pagingAppointmentReject;
    if (current == null) {
      current = PagingResult<AppointmentNewsModel>();
      this.state.pagingAppointmentReject = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    filterQuery.appointmentStatuses = [2];
    final service = ServiceProxy().appointmentServiceProxy;
    var res = await service.getAppointmentNews(
        current.pageNumber = 1, current.pageSize = 10, filterQuery);
    // this.state.appointmentNews = res?.data;
    this.state.pagingAppointmentReject = res;
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

  Future _loadDetailAppointment(String id) async {
    final service = ServiceProxy();
    this.state.detailAppointment =
        await service.appointmentServiceProxy.getDetailAppointment(id);
    if (this.state.detailAppointment != null &&
        this.state.detailAppointment.orderId != null) {
      this.state.order = await service.orderServiceProxy
          .getOder(this.state.detailAppointment.orderId);
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
}
