class OrderModel {
  Family family;
  String note;
  String firstHistory;
  String prescription;
  int clinicId;
  int serviceId;
  String appointmentDate;
  String appointmentTime;
  String paymentMethod;
  int status;
  String transactionId;
  String paymentType;
  String lang;
  int type;
  String orderNo;

  OrderModel(
      {this.family,
      this.note,
      this.firstHistory,
      this.prescription,
      this.clinicId,
      this.serviceId,
      this.appointmentDate,
      this.appointmentTime,
      this.paymentMethod,
      this.status,
      this.transactionId,
      this.paymentType,
      this.lang,
      this.type,
      this.orderNo});

  OrderModel.fromJson(Map<String, dynamic> json) {
    family =
        json['family'] != null ? new Family.fromJson(json['family']) : null;
    note = json['note'];
    firstHistory = json['first_history'];
    prescription = json['prescription'];
    clinicId = json['clinic_Id'];
    serviceId = json['service_id'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    paymentMethod = json['payment_method'];
    status = json['status'];
    transactionId = json['transaction_id'];
    paymentType = json['payment_type'];
    lang = json['lang'];
    type = json['type'];
    orderNo = json['order_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.family != null) {
      data['family'] = this.family.toJson();
    }
    data['note'] = this.note;
    data['first_history'] = this.firstHistory;
    data['prescription'] = this.prescription;
    data['clinic_Id'] = this.clinicId;
    data['service_id'] = this.serviceId;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['payment_method'] = this.paymentMethod;
    data['status'] = this.status;
    data['transaction_id'] = this.transactionId;
    data['payment_type'] = this.paymentType;
    data['lang'] = this.lang;
    data['type'] = this.type;
    data['order_no'] = this.orderNo;
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
  int amount;
  List<String> pharmacys;

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
    pharmacys = json['pharmacys'].cast<String>();
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
