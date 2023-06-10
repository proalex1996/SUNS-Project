import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';

class CreateContactModel {
  CreateContactModel({
    this.fullName,
    this.birthDay,
    this.phoneNumber,
    this.gender,
    this.personalNumber,
    this.relationShip,
    this.email,
    this.address,
    this.note,
    this.history,
  });

  String fullName;
  DateTime birthDay;
  String phoneNumber;
  int gender;
  String personalNumber;
  int relationShip;
  String email;
  String address;
  String note;
  String history;

  factory CreateContactModel.fromContactModel(ContactModel contact) =>
      CreateContactModel(
        fullName: contact.fullName,
        birthDay: contact.birthDay,
        phoneNumber: contact.phoneNumber,
        gender: contact.gender,
        personalNumber: contact.personalNumber,
        relationShip: contact.relationShip,
        email: contact.email,
        address: contact.address,
        note: contact.note,
        history: contact.history,
      );

  factory CreateContactModel.fromJson(Map<String, dynamic> json) =>
      CreateContactModel(
        fullName: json["fullName"],
        birthDay: DateTime.parse(json["birthDay"]),
        phoneNumber: json["phoneNumber"],
        gender: json["gender"],
        personalNumber: json["personalNumber"],
        relationShip: json["relationShip"],
        email: json["email"],
        address: json["address"],
        note: json["note"],
        history: json["history"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "birthDay": birthDay.toIso8601String(),
        "phoneNumber": phoneNumber,
        "gender": gender,
        "personalNumber": personalNumber,
        "relationShip": relationShip,
        "email": email,
        "address": address,
        "note": note,
        "history": history,
      };
}
