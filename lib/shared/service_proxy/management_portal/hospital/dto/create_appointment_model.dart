class CreateAppointmentModel {
  String transactionId;
  String paymentType;
  String lang;
  String orderNo;
  String userName;
  int clinicId;
  double price;
  int doctorId;

  CreateAppointmentModel(
      {this.transactionId,
      this.paymentType,
      this.lang,
      this.orderNo,
      this.userName,
      this.clinicId,
      this.price,
      this.doctorId});

  CreateAppointmentModel.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    paymentType = json['payment_type'];
    lang = json['lang'];
    orderNo = json['order_no'];
    userName = json['user_name'];
    clinicId = json['clinic_id'];
    price = json['price'];
    doctorId = json['doctor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['payment_type'] = this.paymentType;
    data['lang'] = this.lang;
    data['order_no'] = this.orderNo;
    data['user_name'] = this.userName;
    data['clinic_id'] = this.clinicId;
    data['price'] = this.price;
    data['doctor_id'] = this.doctorId;
    return data;
  }
}
