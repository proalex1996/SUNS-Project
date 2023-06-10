import 'package:suns_med/shared/bloc_base.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/gender_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';

class ContactState {
  List<ContactModel> contact;
  List<ContactModel> searchContact;
  ContactModel contactModel;
  List<RelationshipModel> relationship;
  List<GenderModel> gender;
  int totalCost;
  bool deleteContact;
  ContactState(
      {this.contact,
      this.contactModel,
      this.relationship,
      this.gender,
      this.totalCost,
      this.deleteContact});
}

abstract class ContactEvent {}

class LoadContactEvent extends ContactEvent {}

class DeleteContactEvent extends ContactEvent {
  int userId;
  DeleteContactEvent({this.userId});
}

class EventSearchContact extends ContactEvent {
  String keyWord;
  EventSearchContact({this.keyWord});
}

class LoadRelationship extends ContactEvent {}

class LoadGenderEvent extends ContactEvent {}

class LoadTotalCostEvent extends ContactEvent {
  int id;
  LoadTotalCostEvent({this.id});
}

class ResetStateContactEvent extends ContactEvent {}

class ContactBloc extends BlocBase<ContactEvent, ContactState> {
  static final ContactBloc _singleton = ContactBloc._internal();

  factory ContactBloc() {
    return _singleton;
  }

  ContactBloc._internal();
  @override
  void initState() {
    this.state = new ContactState();
    this.useGlobalLoading = false;
    super.initState();
  }

  @override
  Future<ContactState> mapEventToState(ContactEvent event) async {
    if (event is LoadContactEvent) {
      await _loadContact();
    } else if (event is DeleteContactEvent) {
      await _deleteContact(event.userId);
      await _loadContact();
    } else if (event is EventSearchContact) {
      await _getSearchContact(event.keyWord);
    } else if (event is LoadRelationship) {
      await _loadRelationship();
    } else if (event is LoadGenderEvent) {
      await _loadGender();
    } else if (event is LoadTotalCostEvent) {
      await _loadTotalCost(event.id);
    } else if (event is ResetStateContactEvent) {
      this.state.contact = null;
    }

    return this.state;
  }

  Future _loadContact() async {
    final service = ServiceProxy().userService;
    this.state.contact = await service.getContacts();
  }

  Future _deleteContact(int userId) async {
    final service = ServiceProxy();
    await service.userService.deleteContact(userId);
  }

  Future _getSearchContact(String keyWord) async {
    final service = ServiceProxy().userService;
    this.state.searchContact = await service.getSearchContacts(keyWord);
  }

  Future _loadRelationship() async {
    final service = ServiceProxy().commonService;
    this.state.relationship = await service.getAllRelationship();
  }

  Future _loadGender() async {
    final service = ServiceProxy().commonService;
    this.state.gender = await service.getAllGender();
  }

  Future _loadTotalCost(int id) async {
    final service = ServiceProxy().contactSeviceProxy;
    this.state.totalCost = await service.getTotalCost(id);
  }
}
