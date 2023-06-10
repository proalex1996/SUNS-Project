import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/date_off_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/staff_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/working_time_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/gender_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/calendar_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/staff/dto/staff_detail_model.dart';

class OrderState {
  List<ContactModel> contact;
  List<Doctors> doctors;
  List<WorkingTimeModel> workingTimes;
  String workingTimeSelected;
  WorkingTimeModel workingTimeModel;
  String staffId;
  List<StaffModel> staffs;
  List<GenderModel> gender;
  DayOffModel dayOff;
  StaffDetailModel staff;

  OrderState(
      {this.contact,
      this.staffId,
      this.doctors,
      this.workingTimeModel,
      this.gender,
      this.staffs,
      this.workingTimeSelected,
      this.workingTimes,
      this.staff});
}

abstract class OrderEvent {}

class LoadDoctor extends OrderEvent {
  DateTime dateTime;
  LoadDoctor({this.dateTime});
}

class LoadTime extends OrderEvent {
  String id;
  DateTime dateTime;
  LoadTime({this.id, this.dateTime});
}

class ChooseFileEvent extends OrderEvent {}

class ChooseTimeEvent extends OrderEvent {
  String workingTimeSelected;
  WorkingTimeModel workingTimeModel;
  ChooseTimeEvent({this.workingTimeSelected, this.workingTimeModel});
}

class ChooseDoctorEvent extends OrderEvent {
  String staffId;
  ChooseDoctorEvent({this.staffId});
}

class EventCallStaffList extends OrderEvent {
  String serviceId;
  String branchId;
  DateTime dateTime;
  String id;
  EventCallStaffList({this.serviceId, this.branchId, this.dateTime, this.id});
}

class EventCallDayOff extends OrderEvent {
  String companyId;
  EventCallDayOff({this.companyId});
}

class ResetStateEvent extends OrderEvent {
  String workingTimeSelected;
  String staffId;
  ResetStateEvent({this.workingTimeSelected, this.staffId});
}

class EventLoadDetailDoctor extends OrderEvent {
  String doctorId;
  EventLoadDetailDoctor({this.doctorId});
}

class EventLoadGender extends OrderEvent {}

class OrderBloc extends BlocBase<OrderEvent, OrderState> {
  static final OrderBloc _singleton = OrderBloc._internal();

  factory OrderBloc() {
    return _singleton;
  }

  OrderBloc._internal();
  @override
  void initState() {
    this.state = new OrderState();
    super.initState();
  }

  @override
  Future<OrderState> mapEventToState(OrderEvent event) async {
    if (event is ChooseFileEvent) {
      await _loadListFile();
    }
    if (event is LoadDoctor) {
      this.state.doctors = await _loadDoctors(event.dateTime ?? DateTime.now());
    } else if (event is LoadTime) {
      await _getWorkingTime(event.id, event.dateTime);
    } else if (event is ChooseTimeEvent) {
      this.state.workingTimeSelected = event.workingTimeSelected;
      this.state.workingTimeModel = event.workingTimeModel;
    } else if (event is ResetStateEvent) {
      this.state.workingTimeSelected = "";
      this.state.staffId = "";
    } else if (event is EventCallStaffList) {
      await _getListStaffOfServicePackage(
          event.serviceId, event.branchId, event.dateTime);
      this.state.workingTimeSelected = "";
      // await _getWorkingTime(event.id);
    } else if (event is ChooseDoctorEvent) {
      this.state.staffId = event.staffId;
    } else if (event is EventCallDayOff) {
      await _getDayOffCompany(event.companyId);
    } else if (event is EventLoadDetailDoctor) {
      await _loadDetailDoctor(event.doctorId);
    }
    return this.state;
  }

  Future<List<Doctors>> _loadDoctors(DateTime dateTime) async {
    final service = ServiceProxy();
    final calendar = await service.hospitalService.getCalendar();

    if (calendar.length > 0 &&
        dateTime != null &&
        calendar.any((x) => dateTime.difference(x.dateTime).inDays == 0)) {
      //todo Update filter by datetime of calendar
      return Future.value(calendar
          .firstWhere((x) => dateTime.difference(x.dateTime).inDays == 0)
          .doctors);
    }

    return Future.value(null);
  }

  Future _loadListFile() async {
    final service = ServiceProxy();
    this.state.contact = await service.userService.getContacts();
    this.state.gender = await service.commonService.getAllGender();
  }

  Future _getWorkingTime(String id, DateTime dateTime) async {
    final service = ServiceProxy().staffServiceProxy;
    this.state.workingTimes = await service.getWorkingTime(id, dateTime);
  }

  Future _getListStaffOfServicePackage(
      String serviceId, String branchId, DateTime dateTime) async {
    final service = ServiceProxy().packageServiceProxy;
    var res = await service.getStaffOfService(serviceId, branchId, dateTime);
    this.state.staffs = res?.data;
  }

  // Future _loadGender() async {
  //   final service = ServiceProxy().commonService;
  //   this.state.gender = await service.getAllGender();
  // }

  Future _getDayOffCompany(String companyId) async {
    final service = ServiceProxy().companyServiceProxy;
    //Todo can api get company
    var res = await service.getDayOffCompany(companyId);
    this.state.dayOff = res;
  }

  Future _loadDetailDoctor(String doctorId) async {
    final service = ServiceProxy().staffServiceProxy;
    //GetDetail Doctor in widget detai
    var res = await service.getDetailDoctor(doctorId);
    this?.state?.staff = res;
  }
}
