class UserUpdateModel {
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
  String avatar;
  String idCardFront;
  String idCardBack;

  UserUpdateModel(
      {this.fullName,
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
      this.avatar,
      this.idCardFront,
      this.idCardBack});

  UserUpdateModel.fromJson(Map<String, dynamic> json) {
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
    avatar = json['avatar'];
    idCardFront = json['idCardFront'];
    idCardBack = json['idCardBack'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['avatar'] = this.avatar;
    data['idCardFront'] = this.idCardFront;
    data['idCardBack'] = this.idCardBack;
    return data;
  }
}
