class AdressModel {
  String name;
  String phone;
  String address;
  String cityId;
  String provinceId;
  String wardId;

  AdressModel(
      {this.name,
      this.phone,
      this.address,
      this.cityId,
      this.provinceId,
      this.wardId});

  AdressModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    cityId = json['cityId'];
    provinceId = json['provinceId'];
    wardId = json['wardId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['cityId'] = this.cityId;
    data['provinceId'] = this.provinceId;
    data['wardId'] = this.wardId;
    return data;
  }
}

class ResultModel {
  String result;
  bool success;
  String message;

  ResultModel({this.result, this.success, this.message});

  ResultModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class UserAddressModel {
  String id;
  int userId;
  String name;
  String phone;
  String address;

  UserAddressModel({this.id, this.userId, this.name, this.phone, this.address});

  UserAddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    return data;
  }
}
