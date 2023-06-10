class CreateMomoModel {
  String returnUrl;
  String orderId;
  int amount;
  String description;

  CreateMomoModel(
      {this.returnUrl, this.orderId, this.amount, this.description});

  CreateMomoModel.fromJson(Map<String, dynamic> json) {
    returnUrl = json['returnUrl'];
    orderId = json['orderId'];
    amount = json['amount'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['returnUrl'] = this.returnUrl;
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['description'] = this.description;
    return data;
  }
}
