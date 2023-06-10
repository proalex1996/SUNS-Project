class DeepLinkModel {
  String appScheme;
  String merchantCode;
  String merchantName;

  DeepLinkModel({this.appScheme, this.merchantCode, this.merchantName});

  DeepLinkModel.fromJson(Map<String, dynamic> json) {
    appScheme = json['appScheme'];
    merchantCode = json['merchantCode'];
    merchantName = json['merchantName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appScheme'] = this.appScheme;
    data['merchantCode'] = this.merchantCode;
    data['merchantName'] = this.merchantName;
    return data;
  }
}
