class ChangePasswordModel {
  String oldPassword;
  String newPassword;

  ChangePasswordModel({this.oldPassword, this.newPassword});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    oldPassword = json['oldPassword'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oldPassword'] = this.oldPassword;
    data['newPassword'] = this.newPassword;
    return data;
  }
}
