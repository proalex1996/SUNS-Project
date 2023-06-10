class ContactModel {
  ContactModel({
    this.id,
    this.barcode,
    // this.pharmacys,
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
    // this.avatar
  });

  int id;
  String barcode;
  // dynamic pharmacys;
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
  // String avatar;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        id: json["id"],
        barcode: json["barcode"],
        // pharmacys: json["pharmacys"],
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
        // avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "barcode": barcode,
        // "pharmacys": pharmacys,
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
        // "avatar": avatar,
      };
}
