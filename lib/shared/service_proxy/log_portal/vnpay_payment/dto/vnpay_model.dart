class VNPayModel {
  String orderId;
  int amount;
  String orderDescription;
  String bankCode;
  String locale;
  String returnUrl;

  VNPayModel(
      {this.orderId,
      this.amount,
      this.orderDescription,
      this.bankCode,
      this.locale,
      this.returnUrl});

  VNPayModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    amount = json['amount'];
    orderDescription = json['orderDescription'];
    bankCode = json['bankCode'];
    locale = json['locale'];
    returnUrl = json['returnUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['orderDescription'] = this.orderDescription;
    data['bankCode'] = this.bankCode;
    data['locale'] = this.locale;
    data['returnUrl'] = this.returnUrl;
    return data;
  }
}
