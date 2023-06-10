class AppointmentNewsModel {
  AppointmentNewsModel(
      {this.id,
      this.code,
      this.contactId,
      this.isPaid,
      this.appointmentTime,
      this.isAppointmentDateTime,
      this.appointmentOrder,
      this.currentOrder,
      this.status,
      this.paymentMethod,
      this.orderId,
      this.staffId,
      this.staffName,
      this.staffUserId});

  String id;
  String code;
  int contactId;
  bool isPaid;
  DateTime appointmentTime;
  bool isAppointmentDateTime;
  int appointmentOrder;
  int currentOrder;
  int status;
  int paymentMethod;
  String orderId;
  String staffId;
  String staffName;
  int staffUserId;

  factory AppointmentNewsModel.fromJson(Map<String, dynamic> json) =>
      AppointmentNewsModel(
        id: json["id"],
        code: json["code"],
        contactId: json["contactId"],
        isPaid: json["isPaid"],
        appointmentTime: DateTime.parse(json["appointmentTime"]),
        isAppointmentDateTime: json["isAppointmentDateTime"],
        appointmentOrder: json["appointmentOrder"],
        currentOrder: json["currentOrder"],
        status: json["status"],
        paymentMethod:
            json["paymentMethod"] == null ? null : json["paymentMethod"],
        orderId: json["orderId"],
        staffId: json["staffId"] == null ? null : json["staffId"],
        staffName: json["staffName"] == null ? null : json["staffName"],
        staffUserId: json["staffUserId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "contactId": contactId,
        "isPaid": isPaid,
        "appointmentTime": appointmentTime.toIso8601String(),
        "isAppointmentDateTime": isAppointmentDateTime,
        "appointmentOrder": appointmentOrder,
        "currentOrder": currentOrder,
        "status": status,
        "paymentMethod": paymentMethod == null ? null : paymentMethod,
        "orderId": orderId,
        "staffId": staffId == null ? null : staffId,
        "staffName": staffName == null ? null : staffName,
        "staffUserId": staffUserId,
      };
}
