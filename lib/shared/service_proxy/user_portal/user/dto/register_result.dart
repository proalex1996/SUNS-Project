class RegisterResult {
  String id;
  String userName;
  String fullName;
  String email;
  String phoneNumber;
  String address;
  String ward;
  String district;
  String province;
  String national;
  String fullAddress;
  String birthDay;
  int gender;
  String avatar;
  String personalNumber;
  String barcode;
  String idFront;
  String idBack;
  int rating;
  int notifyUnread;
  bool isEmployee;
  int userType;
  int familyId;
  int relationType;
  String specialist;
  int totalView;
  int totalLike;
  int totalShare;
  int latLong;
  String token;

  RegisterResult(
      {this.id,
      this.userName,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.address,
      this.ward,
      this.district,
      this.province,
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
      this.token});

  RegisterResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    fullName = json['fullName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    ward = json['ward'];
    district = json['district'];
    province = json['province'];
    national = json['national'];
    fullAddress = json['fullAddress'];
    birthDay = json['birthDay'];
    gender = json['gender'];
    avatar = json['avatar'];
    personalNumber = json['personalNumber'];
    barcode = json['barcode'];
    idFront = json['idFront'];
    idBack = json['idBack'];
    rating = json['rating'];
    notifyUnread = json['notifyUnread'];
    isEmployee = json['isEmployee'];
    userType = json['userType'];
    familyId = json['familyId'];
    relationType = json['relationType'];
    specialist = json['specialist'];
    totalView = json['totalView'];
    totalLike = json['totalLike'];
    totalShare = json['totalShare'];
    latLong = json['latLong'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['ward'] = this.ward;
    data['district'] = this.district;
    data['province'] = this.province;
    data['national'] = this.national;
    data['fullAddress'] = this.fullAddress;
    data['birthDay'] = this.birthDay;
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    data['personalNumber'] = this.personalNumber;
    data['barcode'] = this.barcode;
    data['idFront'] = this.idFront;
    data['idBack'] = this.idBack;
    data['rating'] = this.rating;
    data['notifyUnread'] = this.notifyUnread;
    data['isEmployee'] = this.isEmployee;
    data['userType'] = this.userType;
    data['familyId'] = this.familyId;
    data['relationType'] = this.relationType;
    data['specialist'] = this.specialist;
    data['totalView'] = this.totalView;
    data['totalLike'] = this.totalLike;
    data['totalShare'] = this.totalShare;
    data['latLong'] = this.latLong;
    data['token'] = this.token;
    return data;
  }
}
