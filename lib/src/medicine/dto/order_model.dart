class OrderModel {
  String id;
  String code;
  int amount;
  String paidTime;
  String transactionId;
  String note;
  bool isPaid;
  String createdTime;
  int paymentMethod;

  OrderModel(
      {this.id,
      this.code,
      this.amount,
      this.paidTime,
      this.transactionId,
      this.note,
      this.isPaid,
      this.createdTime,
      this.paymentMethod});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    amount = json['amount'];
    paidTime = json['paidTime'];
    transactionId = json['transactionId'];
    note = json['note'];
    isPaid = json['isPaid'];
    createdTime = json['createdTime'];
    paymentMethod = json['paymentMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['amount'] = this.amount;
    data['paidTime'] = this.paidTime;
    data['transactionId'] = this.transactionId;
    data['note'] = this.note;
    data['isPaid'] = this.isPaid;
    data['createdTime'] = this.createdTime;
    data['paymentMethod'] = this.paymentMethod;
    return data;
  }
}
