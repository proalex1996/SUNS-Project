class DepartmentSpecialModel {
  String key;
  String value;
  String avatar;

  DepartmentSpecialModel({this.key, this.value, this.avatar});

  DepartmentSpecialModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['avatar'] = this.avatar;
    return data;
  }
}
