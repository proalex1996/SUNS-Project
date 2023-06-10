class HospitalModel {
  int id;
  Null code;
  String name;
  Null email;
  Null phone;
  String address;
  String department;
  int totalRateGood;
  int totalRateBad;
  double totalRates;
  int totalPoint;
  int totalLike;
  Null rateInfo;
  String avatar;
  String latLong;
  int type;
  Null clientInfo;
  Null services;
  bool isBooking;
  String city;
  bool isLike;
  String isBookingString;
  int star;
  Null comment;

  HospitalModel(
      {this.id,
      this.code,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.department,
      this.totalRateGood,
      this.totalRateBad,
      this.totalRates,
      this.totalPoint,
      this.totalLike,
      this.rateInfo,
      this.avatar,
      this.latLong,
      this.type,
      this.clientInfo,
      this.services,
      this.isBooking,
      this.city,
      this.isLike,
      this.isBookingString,
      this.star,
      this.comment});

  HospitalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    department = json['department'];
    totalRateGood = json['total_Rate_Good'];
    totalRateBad = json['total_Rate_Bad'];
    totalRates = json['totalRates'];
    totalPoint = json['total_Point'];
    totalLike = json['totalLike'];
    rateInfo = json['rateInfo'];
    avatar = json['avatar'];
    latLong = json['lat_Long'];
    type = json['type'];
    clientInfo = json['clientInfo'];
    services = json['services'];
    isBooking = json['is_booking'];
    city = json['city'];
    isLike = json['is_like'];
    isBookingString = json['isBooking'];
    star = json['star'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    // ignore: non_constant_identifier_names
    final Map<String, dynamic> HospitalModel = new Map<String, dynamic>();
    HospitalModel['id'] = this.id;
    HospitalModel['code'] = this.code;
    HospitalModel['name'] = this.name;
    HospitalModel['email'] = this.email;
    HospitalModel['phone'] = this.phone;
    HospitalModel['address'] = this.address;
    HospitalModel['department'] = this.department;
    HospitalModel['total_Rate_Good'] = this.totalRateGood;
    HospitalModel['total_Rate_Bad'] = this.totalRateBad;
    HospitalModel['totalRates'] = this.totalRates;
    HospitalModel['total_Point'] = this.totalPoint;
    HospitalModel['totalLike'] = this.totalLike;
    HospitalModel['rateInfo'] = this.rateInfo;
    HospitalModel['avatar'] = this.avatar;
    HospitalModel['lat_Long'] = this.latLong;
    HospitalModel['type'] = this.type;
    HospitalModel['clientInfo'] = this.clientInfo;
    HospitalModel['services'] = this.services;
    HospitalModel['is_booking'] = this.isBooking;
    HospitalModel['city'] = this.city;
    HospitalModel['is_like'] = this.isLike;
    HospitalModel['isBooking'] = this.isBooking;
    HospitalModel['star'] = this.star;
    HospitalModel['comment'] = this.comment;
    return HospitalModel;
  }
}
