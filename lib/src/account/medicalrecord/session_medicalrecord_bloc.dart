import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/appointment_history_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/contact/dto/medical_examination_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';

class MedicalRecordState {
  List<ContactModel> medicalRecord;
  List<ContactModel> contact;
  List<RelationshipModel> relationship;
  List<MedicalExaminationModel> medicalExamination;

  List<AppointmentHistoryModel> medicalHistory;
  MedicalRecordState(
      {this.medicalRecord,
      this.relationship,
      this.medicalExamination,
      this.medicalHistory,
      this.contact});
}

abstract class MedicalRecordEvent {}

class LoadMedicalRecordEvent extends MedicalRecordEvent {}

class DeleteMedicalRecordEvent extends MedicalRecordEvent {
  int userId;
  DeleteMedicalRecordEvent({this.userId});
}

class EventSearchContact extends MedicalRecordEvent {
  String keyWord;
  EventSearchContact({this.keyWord});
}

class LoadRelationshipMedicalEvent extends MedicalRecordEvent {}

class LoadMedicalHistoryEvent extends MedicalRecordEvent {
  String userName;
  LoadMedicalHistoryEvent({this.userName});
}

class CreateContactFileEvent extends MedicalRecordEvent {}

class LoadMedicalExamination extends MedicalRecordEvent {
  int id;
  LoadMedicalExamination({this.id});
}

class MedicalRecordBloc
    extends BlocBase<MedicalRecordEvent, MedicalRecordState> {
  static final MedicalRecordBloc _instance = MedicalRecordBloc._internal();
  MedicalRecordBloc._internal();

  factory MedicalRecordBloc() {
    return _instance;
  }

  @override
  void initState() {
    this.state = new MedicalRecordState();
    super.initState();
  }

  @override
  Future<MedicalRecordState> mapEventToState(MedicalRecordEvent event) async {
    if (event is LoadMedicalRecordEvent) {
      await _getMedicalRecord();
    } else if (event is DeleteMedicalRecordEvent) {
      await _deleteMedicalRecord(event.userId);
      await _getMedicalRecord();
    } else if (event is EventSearchContact) {
      await _getSearchMedicalRecord(event.keyWord);
    }

    if (event is LoadRelationshipMedicalEvent) {
      await _getRelationship();
    }

    if (event is LoadMedicalHistoryEvent) {
      await _getMedicalHistory(event.userName);
    }
    if (event is LoadMedicalExamination) {
      await _loadMedicalExamination(event.id);
    }
    return this.state;
  }

  Future _getMedicalRecord() async {
    final service = ServiceProxy().userService;
    this.state.medicalRecord = await service.getContacts();
  }

  Future _deleteMedicalRecord(int userId) async {
    final service = ServiceProxy();
    await service.userService.deleteContact(userId);
  }

  Future _getSearchMedicalRecord(String keyWord) async {
    final service = ServiceProxy().userService;
    this.state.contact = await service.getSearchContacts(keyWord);
  }

  Future _getRelationship() async {
    final service = ServiceProxy().commonService;
    this.state.relationship = await service.getAllRelationship();
  }

  Future _getMedicalHistory(String userName) async {
    final service = ServiceProxy().hospitalService;
    this.state.medicalHistory = await service.getAppointmentHistory(userName);
  }

  Future _loadMedicalExamination(int id) async {
    final service = ServiceProxy().contactSeviceProxy;
    var res = await service.getMedicalExamination(id);
    this.state.medicalExamination = res?.data;
  }
}
