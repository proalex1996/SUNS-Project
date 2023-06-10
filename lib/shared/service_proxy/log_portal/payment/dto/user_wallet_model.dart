class UserWalletMode {
  double balance;
  int point;
  int rating;

  UserWalletMode({this.balance, this.point, this.rating});

  UserWalletMode.fromJson(Map<String, dynamic> json) {
    balance = double.parse(json['balance']?.toString());
    point = json['point'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['point'] = this.point;
    data['rating'] = this.rating;
    return data;
  }
}
