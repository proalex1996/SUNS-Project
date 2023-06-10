class OrderResult {
  String orderNo;
  String paymentType;
  String billDate;
  double priceTemp;
  double price;
  String packageName;
  String packageDescript;
  String packageImg;
  String status;

  OrderResult(
      {this.orderNo,
      this.paymentType,
      this.billDate,
      this.priceTemp,
      this.price,
      this.packageName,
      this.packageDescript,
      this.packageImg,
      this.status});

  OrderResult.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    paymentType = json['payment_type'];
    billDate = json['bill_date'];
    priceTemp = json['price_temp'];
    price = json['price'];
    packageName = json['package_name'];
    packageDescript = json['package_descript'];
    packageImg = json['package_img'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_no'] = this.orderNo;
    data['payment_type'] = this.paymentType;
    data['bill_date'] = this.billDate;
    data['price_temp'] = this.priceTemp;
    data['price'] = this.price;
    data['package_name'] = this.packageName;
    data['package_descript'] = this.packageDescript;
    data['package_img'] = this.packageImg;
    data['status'] = this.status;
    return data;
  }
}
