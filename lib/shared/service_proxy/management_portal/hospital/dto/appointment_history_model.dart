class AppointmentHistoryModel {
  Family family;
  String clinicName;
  String clinicPhone;
  String email;
  bool isChat;
  bool isVideo;
  String orderNo;
  String status;
  String appointDate;

  AppointmentHistoryModel(
      {this.family,
      this.clinicName,
      this.clinicPhone,
      this.email,
      this.isChat,
      this.isVideo,
      this.orderNo,
      this.status,
      this.appointDate});

  AppointmentHistoryModel.fromJson(Map<String, dynamic> json) {
    family =
        json['family'] != null ? new Family.fromJson(json['family']) : null;
    clinicName = json['clinic_name'];
    clinicPhone = json['clinic_phone'];
    email = json['email'];
    isChat = json['is_chat'];
    isVideo = json['is_video'];
    orderNo = json['order_no'];
    status = json['status'];
    appointDate = json['appoint_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.family != null) {
      data['family'] = this.family.toJson();
    }
    data['clinic_name'] = this.clinicName;
    data['clinic_phone'] = this.clinicPhone;
    data['email'] = this.email;
    data['is_chat'] = this.isChat;
    data['is_video'] = this.isVideo;
    data['order_no'] = this.orderNo;
    data['status'] = this.status;
    data['appoint_date'] = this.appointDate;
    return data;
  }
}

class Family {
  int id;
  String fullName;
  String birthDay;
  String phoneNumber;
  int gender;
  String personalNumber;
  int relationShip;
  String note;
  int userId;
  String email;
  String address;
  String history;
  String phamarcyUrl;
  String barcode;
  double amount;
  Null pharmacys;

  Family(
      {this.id,
      this.fullName,
      this.birthDay,
      this.phoneNumber,
      this.gender,
      this.personalNumber,
      this.relationShip,
      this.note,
      this.userId,
      this.email,
      this.address,
      this.history,
      this.phamarcyUrl,
      this.barcode,
      this.amount,
      this.pharmacys});

  Family.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    birthDay = json['birthDay'];
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];
    personalNumber = json['personalNumber'];
    relationShip = json['relationShip'];
    note = json['note'];
    userId = json['userId'];
    email = json['email'];
    address = json['address'];
    history = json['history'];
    phamarcyUrl = json['phamarcy_url'];
    barcode = json['barcode'];
    amount = json['amount'];
    pharmacys = json['pharmacys'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['birthDay'] = this.birthDay;
    data['phoneNumber'] = this.phoneNumber;
    data['gender'] = this.gender;
    data['personalNumber'] = this.personalNumber;
    data['relationShip'] = this.relationShip;
    data['note'] = this.note;
    data['userId'] = this.userId;
    data['email'] = this.email;
    data['address'] = this.address;
    data['history'] = this.history;
    data['phamarcy_url'] = this.phamarcyUrl;
    data['barcode'] = this.barcode;
    data['amount'] = this.amount;
    data['pharmacys'] = this.pharmacys;
    return data;
  }
}
