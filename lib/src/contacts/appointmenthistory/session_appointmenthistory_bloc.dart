import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/appointment_history_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/bmi_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/result_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/contact/dto/medical_examination_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/medicalexamination/dto/detail_medicalexam_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/medicalexamination/dto/examination_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/medicalexamination/dto/input_rating_model.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';

class AppointmentHistoryState {
  List<AppointmentHistoryModel> appointmentHistory;
  List<RelationshipModel> relationship;
  List<MedicalExaminationModel> medicalExamination;
  DetailMedicalExaminationModel detailMedicalExamination;
  List<ExaminationModel> examination;
  bool isRated;
  bool isAllowed;
  BMIModel bmi;
  ResultModel result;
  AppointmentHistoryState({
    this.isAllowed,
    this.appointmentHistory,
    this.relationship,
    this.bmi,
    this.result,
    this.medicalExamination,
    this.detailMedicalExamination,
    this.examination,
    this.isRated,
  });
}

abstract class AppointmentHistoryEvent {}

class LoadAppointmentHistoryEvent extends AppointmentHistoryEvent {
  String userName;
  LoadAppointmentHistoryEvent({this.userName});
}

class LoadRelationshipHistoryEvent extends AppointmentHistoryEvent {}

class LoadBMIEvent extends AppointmentHistoryEvent {
  String userName;
  LoadBMIEvent({this.userName});
}

class LoadResultEvent extends AppointmentHistoryEvent {
  String userName;
  int id;
  LoadResultEvent({this.userName, this.id});
}

class LoadMedicalExamination extends AppointmentHistoryEvent {
  int id;
  LoadMedicalExamination({this.id});
}

class LoadDetailMedicalExamination extends AppointmentHistoryEvent {
  String id;
  LoadDetailMedicalExamination({this.id});
}

class LoadExamination extends AppointmentHistoryEvent {
  String id;
  LoadExamination({this.id});
}

class PostRatingEvent extends AppointmentHistoryEvent {
  String id;
  InputRatingCommentModel inputRatingComment;
  PostRatingEvent({this.id, this.inputRatingComment});
}

class AllowedRatingEvent extends AppointmentHistoryEvent {
  String idExamination;
  AllowedRatingEvent({this.idExamination});
}

class AppointmentHistoryBloc
    extends BlocBase<AppointmentHistoryEvent, AppointmentHistoryState> {
  InputRatingCommentModel _inputRatingComment = InputRatingCommentModel();
  @override
  void initState() {
    this.state = new AppointmentHistoryState();
    super.initState();
  }

  @override
  Future<AppointmentHistoryState> mapEventToState(
      AppointmentHistoryEvent event) async {
    if (event is LoadAppointmentHistoryEvent) {
      await _getAppointmentHistory(event.userName);
    } else if (event is LoadRelationshipHistoryEvent) {
      await _getRelationship();
    } else if (event is LoadBMIEvent) {
      await _getBMI(event.userName);
    } else if (event is LoadResultEvent) {
      await _getResult(event.userName, event.id);
    } else if (event is LoadMedicalExamination) {
      await _loadMedicalExamination(event.id);
    } else if (event is LoadDetailMedicalExamination) {
      await _loadDetailMedicalExamination(event.id);
      await _getAllowedRating(event.id);
    } else if (event is LoadExamination) {
      await _loadExamination(event.id);
    } else if (event is PostRatingEvent) {
      await _postCommentRating(event.inputRatingComment, event.id);
    } else if (event is AllowedRatingEvent) {
      await _getAllowedRating(event.idExamination);
    }
    return this.state;
  }

  Future _getAppointmentHistory(String userName) async {
    final service = ServiceProxy().hospitalService;
    this.state.appointmentHistory =
        await service.getAppointmentHistory(userName);
  }

  Future _getRelationship() async {
    final service = ServiceProxy().commonService;
    this.state.relationship = await service.getAllRelationship();
  }

  Future _getBMI(String userName) async {
    final service = ServiceProxy().hospitalService;
    this.state.bmi = await service.getBMI(userName);
  }

  Future _getResult(String userName, int id) async {
    final service = ServiceProxy().hospitalService;
    this.state.result = await service.getResult(id, userName);
  }

  Future _loadMedicalExamination(int id) async {
    final service = ServiceProxy().contactSeviceProxy;
    var res = await service.getMedicalExamination(id);
    this.state.medicalExamination = res?.data;
  }

  Future _loadDetailMedicalExamination(String id) async {
    final service = ServiceProxy().medicalExaminationSeviceProxy;
    this.state.detailMedicalExamination =
        await service.getDetailMedicalExamination(id);
  }

  Future _loadExamination(String id) async {
    final service = ServiceProxy().medicalExaminationSeviceProxy;
    this.state.examination = await service.getExamination(id);
  }

  Future _postCommentRating(
      InputRatingCommentModel inputRatingComment, String id) async {
    final service = ServiceProxy().medicalExaminationSeviceProxy;
    _inputRatingComment = inputRatingComment;

    this.state.isRated = await service.postComment(_inputRatingComment, id);
  }

  Future _getAllowedRating(String idExamination) async {
    final service = ServiceProxy().medicalExaminationSeviceProxy;
    this.state.isAllowed = await service.getAllowedRating(idExamination);
  }
}
