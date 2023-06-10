class PostAppointmentModel {
  PostAppointmentModel({
    this.contactId,
    this.name,
    this.firstHistory,
    this.prescriptionFile,
    this.appointmentTime,
    this.note,
    this.staffId,
    this.servicePackageId,
    this.branchId,
  });

  int contactId;
  String name;
  String firstHistory;
  String prescriptionFile;
  DateTime appointmentTime;
  String note;
  String staffId;
  String servicePackageId;
  String branchId;

  factory PostAppointmentModel.fromJson(Map<String, dynamic> json) =>
      PostAppointmentModel(
        contactId: json["contactId"],
        name: json["name"],
        firstHistory: json["firstHistory"],
        prescriptionFile: json["prescriptionFile"],
        appointmentTime: DateTime.parse(json["appointmentTime"]),
        note: json["note"],
        staffId: json["staffId"],
        servicePackageId: json["servicePackageId"],
        branchId: json["branchId"],
      );

  Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "name": name,
        "firstHistory": firstHistory,
        "prescriptionFile": prescriptionFile,
        "appointmentTime": appointmentTime.toIso8601String(),
        "note": note,
        "staffId": staffId,
        "servicePackageId": servicePackageId,
        "branchId": branchId,
      };
}
