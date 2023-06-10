// class ExamServicesModel {
//   ExamServicesModel({
//     this.id,
//     this.order,
//     this.currentOrder,
//     this.status,
//     this.examTime,
//     this.patientName,
//     this.departmentName,
//   });

//   String id;
//   int order;
//   int currentOrder;
//   int status;
//   DateTime examTime;
//   String patientName;
//   String departmentName;

//   factory ExamServicesModel.fromJson(Map<String, dynamic> json) =>
//       ExamServicesModel(
//         id: json["id"],
//         order: json["order"],
//         currentOrder: json["currentOrder"],
//         status: json["status"],
//         examTime: DateTime.parse(json["examTime"]),
//         patientName: json["patientName"],
//         departmentName: json["departmentName"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "order": order,
//         "currentOrder": currentOrder,
//         "status": status,
//         "examTime": examTime.toIso8601String(),
//         "patientName": patientName,
//         "departmentName": departmentName,
//       };
// }
class ExamServicesModel {
  ExamServicesModel({
    this.name,
    this.ordinalNumber,
    this.currentOrdinalNumber,
    this.status,
    this.examTime,
    this.patientName,
    this.staffId,
    this.staffName,
    this.medicalExaminationId,
  });

  String name;
  int ordinalNumber;
  int currentOrdinalNumber;
  int status;
  DateTime examTime;
  String patientName;
  dynamic staffId;
  dynamic staffName;
  dynamic medicalExaminationId;

  factory ExamServicesModel.fromJson(Map<String, dynamic> json) =>
      ExamServicesModel(
        name: json["name"],
        ordinalNumber: json["ordinalNumber"],
        currentOrdinalNumber: json["currentOrdinalNumber"],
        status: json["status"],
        examTime:
            json["examTime"] != null ? DateTime.parse(json["examTime"]) : null,
        patientName: json["patientName"],
        staffId: json["staffId"],
        staffName: json["staffName"],
        medicalExaminationId: json["medicalExaminationId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "ordinalNumber": ordinalNumber,
        "currentOrdinalNumber": currentOrdinalNumber,
        "status": status,
        "examTime": examTime.toIso8601String(),
        "patientName": patientName,
        "staffId": staffId,
        "staffName": staffName,
        "medicalExaminationId": medicalExaminationId,
      };
}
