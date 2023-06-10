class JsonResponseResult {
  bool success;
  String message;
  dynamic data;

  JsonResponseResult({
    this.success,
    this.message,
    this.data,
  });

  JsonResponseResult.fromJson(Map<String, dynamic> json) {
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

class EndUserJsonResponseResult {
  bool success;
  String message;
  dynamic result;

  EndUserJsonResponseResult({
    this.success,
    this.message,
    this.result,
  });

  EndUserJsonResponseResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}
