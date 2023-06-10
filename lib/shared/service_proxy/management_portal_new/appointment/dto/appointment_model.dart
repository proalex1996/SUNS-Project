class InputAppointmentModel {
  int patientId;
  String firstHistory;
  String prescriptionFile;
  String appointmentTime;
  String note;
  String companyId;
  Null staffId;
  String servicePackageId;

  InputAppointmentModel(
      {this.patientId,
      this.firstHistory,
      this.prescriptionFile,
      this.appointmentTime,
      this.note,
      this.companyId,
      this.staffId,
      this.servicePackageId});

  InputAppointmentModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    firstHistory = json['firstHistory'];
    prescriptionFile = json['prescriptionFile'];
    appointmentTime = json['appointmentTime'];
    note = json['note'];
    companyId = json['companyId'];
    staffId = json['staffId'];
    servicePackageId = json['servicePackageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['firstHistory'] = this.firstHistory;
    data['prescriptionFile'] = this.prescriptionFile;
    data['appointmentTime'] = this.appointmentTime;
    data['note'] = this.note;
    data['companyId'] = this.companyId;
    data['staffId'] = this.staffId;
    data['servicePackageId'] = this.servicePackageId;
    return data;
  }
}
