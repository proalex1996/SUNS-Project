class UsagePolicyModel {
  bool success;
  String message;
  String data;

  UsagePolicyModel({this.success, this.message, this.data});

  UsagePolicyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
// class UsagePolicyModel {
//   String data;

//   UsagePolicyModel({this.data});

//   UsagePolicyModel.fromJson(Map<String, dynamic> json) {
//     data = json['data'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['data'] = this.data;
//     return data;
//   }
// }