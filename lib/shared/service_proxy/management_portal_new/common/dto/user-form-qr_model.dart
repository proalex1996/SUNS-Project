class UserFromQrCodeModel {
  UserFromQrCodeModel({
    this.code,
    this.name,
    this.birthday,
    this.gender,
    this.address,
    this.provinceCode,
    this.placeHealthcareCode,
    this.applyDate,
    this.expiryDate,
  });

  String code;
  String name;
  DateTime birthday;
  int gender;
  String address;
  String provinceCode;
  String placeHealthcareCode;
  DateTime applyDate;
  DateTime expiryDate;

  factory UserFromQrCodeModel.fromJson(Map<String, dynamic> json) =>
      UserFromQrCodeModel(
        code: json["code"],
        name: json["name"],
        birthday: DateTime.parse(json["birthday"]),
        gender: json["gender"],
        address: json["address"],
        provinceCode: json["provinceCode"],
        placeHealthcareCode: json["placeHealthcareCode"],
        applyDate: DateTime.parse(json["applyDate"]),
        expiryDate: DateTime.parse(json["expiryDate"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "birthday": birthday.toIso8601String(),
        "gender": gender,
        "address": address,
        "provinceCode": provinceCode,
        "placeHealthcareCode": placeHealthcareCode,
        "applyDate": applyDate.toIso8601String(),
        "expiryDate": expiryDate.toIso8601String(),
      };
}
