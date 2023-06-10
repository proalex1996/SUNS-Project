class NotifyModel {
  int id;
  String title;
  String subTitle;
  String content;
  String createdAt;
  bool isRead;
  int type;
  Appointment appointment;
  Null reason;
  List<Clinics> clinics;

  NotifyModel(
      {this.id,
      this.title,
      this.subTitle,
      this.content,
      this.createdAt,
      this.isRead,
      this.type,
      this.appointment,
      this.reason,
      this.clinics});

  NotifyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['sub_title'];
    content = json['content'];
    createdAt = json['created_at'];
    isRead = json['is_read'];
    type = json['type'];
    appointment = json['appointment'] != null
        ? new Appointment.fromJson(json['appointment'])
        : null;
    reason = json['reason'];
    if (json['clinics'] != null) {
      clinics = new List<Clinics>();
      json['clinics'].forEach((v) {
        clinics.add(new Clinics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sub_title'] = this.subTitle;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['is_read'] = this.isRead;
    data['type'] = this.type;
    if (this.appointment != null) {
      data['appointment'] = this.appointment.toJson();
    }
    data['reason'] = this.reason;
    if (this.clinics != null) {
      data['clinics'] = this.clinics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clinics {
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

  Clinics(
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

  Clinics.fromJson(Map<String, dynamic> json) {
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
    isBookingString = json['isBookingString'];
    star = json['star'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['department'] = this.department;
    data['total_Rate_Good'] = this.totalRateGood;
    data['total_Rate_Bad'] = this.totalRateBad;
    data['totalRates'] = this.totalRates;
    data['total_Point'] = this.totalPoint;
    data['totalLike'] = this.totalLike;
    data['rateInfo'] = this.rateInfo;
    data['avatar'] = this.avatar;
    data['lat_Long'] = this.latLong;
    data['type'] = this.type;
    data['clientInfo'] = this.clientInfo;
    data['services'] = this.services;
    data['is_booking'] = this.isBooking;
    data['city'] = this.city;
    data['is_like'] = this.isLike;
    data['isBookingString'] = this.isBookingString;
    data['star'] = this.star;
    data['comment'] = this.comment;
    return data;
  }
}
class Appointment {
  int appointmentId;
  String examDate;
  String examHour;
  Clinic clinic;

  Appointment({this.appointmentId, this.examDate, this.examHour, this.clinic});

  Appointment.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    examDate = json['exam_date'];
    examHour = json['exam_hour'];
    clinic =
        json['clinic'] != null ? new Clinic.fromJson(json['clinic']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_id'] = this.appointmentId;
    data['exam_date'] = this.examDate;
    data['exam_hour'] = this.examHour;
    if (this.clinic != null) {
      data['clinic'] = this.clinic.toJson();
    }
    return data;
  }
}

class Clinic {
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

  Clinic(
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

  Clinic.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['department'] = this.department;
    data['total_Rate_Good'] = this.totalRateGood;
    data['total_Rate_Bad'] = this.totalRateBad;
    data['totalRates'] = this.totalRates;
    data['total_Point'] = this.totalPoint;
    data['totalLike'] = this.totalLike;
    data['rateInfo'] = this.rateInfo;
    data['avatar'] = this.avatar;
    data['lat_Long'] = this.latLong;
    data['type'] = this.type;
    data['clientInfo'] = this.clientInfo;
    data['services'] = this.services;
    data['is_booking'] = this.isBooking;
    data['city'] = this.city;
    data['is_like'] = this.isLike;
    data['isBooking'] = this.isBookingString;
    data['star'] = this.star;
    data['comment'] = this.comment;
    return data;
  }
}