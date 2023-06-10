class DetailAppointmentModel {
  DetailAppointmentModel({
    this.code,
    this.name,
    this.order,
    this.currentOrder,
    this.contactId,
    this.firstHistory,
    this.prescription,
    this.prescriptions,
    this.appointmentTime,
    this.isAppointmentDateTime,
    this.orderId,
    this.isPaid,
    this.paymentMethod,
    this.note,
    this.status,
    this.servicePackageId,
    this.staffId,
    this.staffUserId,
    this.companyId,
    this.companyDepartmentId,
    this.companyDepartmentName,
    this.staffName,
    this.staffPhone,
    this.staffEmail,
    this.staffImage,
    this.staffRating,
    this.staffSpecialize,
    this.branchId,
    this.branchName,
    this.countDownDay,
    this.countDownHour,
  });

  String code;
  String name;
  String order;
  int currentOrder;
  int contactId;
  String firstHistory;
  String prescription;
  String prescriptions;
  DateTime appointmentTime;
  bool isAppointmentDateTime;
  String orderId;
  bool isPaid;
  int paymentMethod;
  String note;
  int status;
  String servicePackageId;
  String staffId;
  int staffUserId;
  String companyId;
  String companyDepartmentId;
  String companyDepartmentName;
  String staffName;
  String staffPhone;
  String staffEmail;
  String staffImage;
  double staffRating;
  String staffSpecialize;
  String branchId;
  String branchName;
  int countDownDay;
  int countDownHour;

  factory DetailAppointmentModel.fromJson(Map<String, dynamic> json) =>
      DetailAppointmentModel(
        code: json["code"],
        name: json["name"],
        order: json["order"],
        currentOrder: json["currentOrder"],
        contactId: json["contactId"],
        firstHistory: json["firstHistory"],
        prescription: json["prescription"],
        prescriptions: json["prescriptions"],
        appointmentTime: DateTime.parse(json["appointmentTime"]),
        isAppointmentDateTime: json["isAppointmentDateTime"],
        orderId: json["orderId"],
        isPaid: json["isPaid"],
        paymentMethod: json["paymentMethod"],
        note: json["note"],
        status: json["status"],
        servicePackageId: json["servicePackageId"],
        staffId: json["staffId"],
        staffUserId: json["staffUserId"],
        companyId: json["companyId"],
        companyDepartmentId: json["companyDepartmentId"],
        companyDepartmentName: json["companyDepartmentName"],
        staffName: json["staffName"],
        staffPhone: json["staffPhone"],
        staffEmail: json["staffEmail"],
        staffImage: json["staffImage"],
        staffRating: json["staffRating"],
        staffSpecialize: json["staffSpecialize"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        countDownDay: json["countDownDay"],
        countDownHour: json["countDownHour"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "order": order,
        "currentOrder": currentOrder,
        "contactId": contactId,
        "firstHistory": firstHistory,
        "prescription": prescription,
        "prescriptions": prescriptions,
        "appointmentTime": appointmentTime.toIso8601String(),
        "isAppointmentDateTime": isAppointmentDateTime,
        "orderId": orderId,
        "isPaid": isPaid,
        "paymentMethod": paymentMethod,
        "note": note,
        "status": status,
        "servicePackageId": servicePackageId,
        "staffId": staffId,
        "staffUserId": staffUserId,
        "companyId": companyId,
        "companyDepartmentId": companyDepartmentId,
        "companyDepartmentName": companyDepartmentName,
        "staffName": staffName,
        "staffPhone": staffPhone,
        "staffEmail": staffEmail,
        "staffImage": staffImage,
        "staffRating": staffRating,
        "staffSpecialize": staffSpecialize,
        "branchId": branchId,
        "branchName": branchName,
        "countDownDay": countDownDay,
        "countDownHour": countDownHour,
      };
}
