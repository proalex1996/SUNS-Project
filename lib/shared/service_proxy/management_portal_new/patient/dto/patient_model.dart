class PatientModel {
  int result;
  bool success;

  PatientModel({this.result, this.success});

  PatientModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['success'] = this.success;
    return data;
  }
}
