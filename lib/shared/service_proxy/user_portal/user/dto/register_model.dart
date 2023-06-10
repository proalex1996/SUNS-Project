class RegisterModel {
  String userName;
  String fullName;
  int gender;
  String birthDay;
  String personalNumber;
  String email;
  String phoneNumber;
  String address;
  String ward;
  String district;
  String province;
  String national;
  String password;
  int userType;
  int familyId;
  int relationType;
  String deviceToken;
  int companyId;
  int applicationId;

  RegisterModel(
      {this.userName,
      this.fullName,
      this.gender,
      this.birthDay,
      this.personalNumber,
      this.email,
      this.phoneNumber,
      this.address,
      this.ward,
      this.district,
      this.province,
      this.national,
      this.password,
      this.userType,
      this.familyId,
      this.relationType,
      this.deviceToken,
      this.companyId,
      this.applicationId});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    fullName = json['fullName'];
    gender = json['gender'];
    birthDay = json['birthDay'];
    personalNumber = json['personalNumber'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    ward = json['ward'];
    district = json['district'];
    province = json['province'];
    national = json['national'];
    password = json['password'];
    userType = json['userType'];
    familyId = json['familyId'];
    relationType = json['relationType'];
    deviceToken = json['deviceToken'];
    companyId = json['companyId'];
    applicationId = json['applicationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['fullName'] = this.fullName;
    data['gender'] = this.gender;
    data['birthDay'] = this.birthDay;
    data['personalNumber'] = this.personalNumber;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['ward'] = this.ward;
    data['district'] = this.district;
    data['province'] = this.province;
    data['national'] = this.national;
    data['password'] = this.password;
    data['userType'] = this.userType;
    data['familyId'] = this.familyId;
    data['relationType'] = this.relationType;
    data['deviceToken'] = this.deviceToken;
    data['companyId'] = this.companyId;
    data['applicationId'] = this.applicationId;
    return data;
  }
}
