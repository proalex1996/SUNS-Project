class WalletHistoryModel {
  int id;
  double currentAmount;
  double amount;
  String provider;
  String description;
  String createOn;
  int createBy;

  WalletHistoryModel(
      {this.id,
      this.currentAmount,
      this.amount,
      this.provider,
      this.description,
      this.createOn,
      this.createBy});

  WalletHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentAmount = json['currentAmount'];
    amount = json['amount'];
    provider = json['provider'];
    description = json['description'];
    createOn = json['createOn'];
    createBy = json['createBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['currentAmount'] = this.currentAmount;
    data['amount'] = this.amount;
    data['provider'] = this.provider;
    data['description'] = this.description;
    data['createOn'] = this.createOn;
    data['createBy'] = this.createBy;
    return data;
  }
}