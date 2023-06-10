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

class AppointmentDoneState {
  PagingResult<AppointmentNewsModel> pagingAppointmentDone;
  PagingResult<ExamServicesModel> examService;
  List<RelationshipModel> relationship;
  List<ContactModel> contact;
  ContactModel contactModel;
  DetailAppointmentModel detailAppointment;
  OrderModelNew order;

  AppointmentDoneState(
      {this.relationship,
      this.contact,
      this.order,
      this.detailAppointment,
      this.contactModel});
}

abstract class AppointmentDoneEvent {}

class EventLoadMoreAppointmentDone extends AppointmentDoneEvent {
  String userName;
  AppointmentFilterQuery filterQuery;
  EventLoadMoreAppointmentDone({this.userName, this.filterQuery});
}

class EventLoadAppointmentDone extends AppointmentDoneEvent {
  AppointmentFilterQuery filterQuery;
  EventLoadAppointmentDone({this.filterQuery});
}

class LoadRelationshipEvent extends AppointmentDoneEvent {}

class LoadContactEvent extends AppointmentDoneEvent {}

class LoadDetailAppointmenDonetvent extends AppointmentDoneEvent {
  String id;
  LoadDetailAppointmenDonetvent({this.id});
}

class EventLoadExamServices extends AppointmentDoneEvent {
  String id;
  EventLoadExamServices({this.id});
}

class EventAddMoreExamServices extends AppointmentDoneEvent {
  String id;
  EventAddMoreExamServices({this.id});
}

class EventInputOrdinalNumberDone extends AppointmentDoneEvent {
  InputPrintOrdinalNumberModel printOrdinalNumberModel;

  EventInputOrdinalNumberDone({this.printOrdinalNumberModel});
}

class AppointmentDoneBloc
    extends BlocBase<AppointmentDoneEvent, AppointmentDoneState> {
  static final AppointmentDoneBloc _instance = AppointmentDoneBloc._internal();
  AppointmentDoneBloc._internal();

  factory AppointmentDoneBloc() {
    return _instance;
  }
  @override
  void initState() {
    this.state = new AppointmentDoneState();
    this.state.pagingAppointmentDone = PagingResult<AppointmentNewsModel>();
    this.state.examService = PagingResult<ExamServicesModel>();
    super.initState();
  }

  @override
  Future<AppointmentDoneState> mapEventToState(
      AppointmentDoneEvent event) async {
    if (event is EventLoadMoreAppointmentDone) {
      // await _loaAppointment(event.userName);
      var current = this.state.pagingAppointmentDone;
      await _addMoreDataN(current, event.filterQuery);
      // this.state.appointmentNews = current.data;
    } else if (event is EventLoadAppointmentDone) {
      await _loadAppointmentNews(event.filterQuery);
      await _loadContact();
      await _loadRelationship();
    } else if (event is LoadRelationshipEvent) {
      await _loadRelationship();
    } else if (event is LoadContactEvent) {
      await _loadContact();
    } else if (event is LoadDetailAppointmenDonetvent) {
      await _loadDetailAppointment(event.id);
    } else if (event is EventInputOrdinalNumberDone) {
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
    var current = this.state.pagingAppointmentDone;
    if (current == null) {
      current = PagingResult<AppointmentNewsModel>();
      this.state.pagingAppointmentDone = current;
    } else {
      current.data = null;
      current.pageNumber = 1;
    }
    filterQuery.appointmentStatuses = [1];
    final service = ServiceProxy().appointmentServiceProxy;
    var res = await service.getAppointmentNews(
        current.pageNumber = 1, current.pageSize = 10, filterQuery);
    // this.state.appointmentNews = res?.data;
    this.state.pagingAppointmentDone = res;
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
