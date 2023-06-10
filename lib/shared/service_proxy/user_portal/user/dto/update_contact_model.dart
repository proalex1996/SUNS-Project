class UpdateContactModel {
  UpdateContactModel({
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

  factory UpdateContactModel.fromJson(Map<String, dynamic> json) =>
      UpdateContactModel(
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
