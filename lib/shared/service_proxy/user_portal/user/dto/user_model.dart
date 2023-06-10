class UserModel {
  UserModel({
    this.id,
    this.userName,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.address,
    this.ward,
    this.wardId,
    this.district,
    this.districtId,
    this.province,
    this.provinceId,
    this.national,
    this.fullAddress,
    this.birthDay,
    this.gender,
    this.avatar,
    this.personalNumber,
    this.barcode,
    this.idFront,
    this.idBack,
    this.rating,
    this.notifyUnread,
    this.isEmployee,
    this.userType,
    this.familyId,
    this.relationType,
    this.specialist,
    this.totalView,
    this.totalLike,
    this.totalShare,
    this.latLong,
    this.token,
  });

  String id;
  String userName;
  String fullName;
  String email;
  String phoneNumber;
  String address;
  String ward;
  String wardId;
  String district;
  String districtId;
  String province;
  String provinceId;
  String national;
  dynamic fullAddress;
  DateTime birthDay;
  int gender;
  String avatar;
  String personalNumber;
  String barcode;
  dynamic idFront;
  dynamic idBack;
  int rating;
  int notifyUnread;
  bool isEmployee;
  int userType;
  int familyId;
  int relationType;
  dynamic specialist;
  int totalView;
  int totalLike;
  int totalShare;
  int latLong;
  dynamic token;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        userName: json["userName"],
        fullName: json["fullName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        ward: json["ward"],
        wardId: json["wardId"],
        district: json["district"],
        districtId: json["districtId"],
        province: json["province"],
        provinceId: json["provinceId"],
        national: json["national"],
        fullAddress: json["fullAddress"],
        birthDay: DateTime.parse(json["birthDay"]),
        gender: json["gender"],
        avatar: json["avatar"],
        personalNumber: json["personalNumber"],
        barcode: json["barcode"],
        idFront: json["idFront"],
        idBack: json["idBack"],
        rating: json["rating"],
        notifyUnread: json["notifyUnread"],
        isEmployee: json["isEmployee"],
        userType: json["userType"],
        familyId: json["familyId"],
        relationType: json["relationType"],
        specialist: json["specialist"],
        totalView: json["totalView"],
        totalLike: json["totalLike"],
        totalShare: json["totalShare"],
        latLong: json["latLong"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "address": address,
        "ward": ward,
        "wardId": wardId,
        "district": district,
        "districtId": districtId,
        "province": province,
        "provinceId": provinceId,
        "national": national,
        "fullAddress": fullAddress,
        "birthDay": birthDay.toIso8601String(),
        "gender": gender,
        "avatar": avatar,
        "personalNumber": personalNumber,
        "barcode": barcode,
        "idFront": idFront,
        "idBack": idBack,
        "rating": rating,
        "notifyUnread": notifyUnread,
        "isEmployee": isEmployee,
        "userType": userType,
        "familyId": familyId,
        "relationType": relationType,
        "specialist": specialist,
        "totalView": totalView,
        "totalLike": totalLike,
        "totalShare": totalShare,
        "latLong": latLong,
        "token": token,
      };
}
