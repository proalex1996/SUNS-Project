class LoginModel {
  int companyId;
  int applicationId;
  String userName;
  String password;
  String deviceToken;

  LoginModel({
    this.companyId,
    this.applicationId,
    this.userName,
    this.password,
    this.deviceToken,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    applicationId = json['applicationId'];
    userName = json['userName'];
    password = json['password'];
    deviceToken = json['deviceToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['applicationId'] = this.applicationId;
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['deviceToken'] = this.deviceToken;
    return data;
  }
}
