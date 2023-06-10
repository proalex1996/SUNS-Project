class CheckExistPhoneModel {
  String phoneNumber;

  CheckExistPhoneModel({this.phoneNumber});

  CheckExistPhoneModel.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
