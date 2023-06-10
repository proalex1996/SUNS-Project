class TotalCostModel {
  int result;
  bool success;
  Null message;

  TotalCostModel({this.result, this.success, this.message});

  TotalCostModel.fromJson(Map<String, dynamic> json) {
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
