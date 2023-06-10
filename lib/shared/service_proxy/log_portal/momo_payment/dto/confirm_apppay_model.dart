class ConfirmAppPayMomoModel {
  ConfirmAppPayMomoModel({
    this.momoToken,
    this.customerNumber,
    this.description,
    this.partnerCode,
    this.partnerRefId,
    this.amount,
    this.partnerName,
    this.partnerTransId,
    this.storeId,
    this.storeName,
  });

  String momoToken;
  String customerNumber;
  String description;
  String partnerCode;
  String partnerRefId;
  int amount;
  String partnerName;
  String partnerTransId;
  String storeId;
  String storeName;

  factory ConfirmAppPayMomoModel.fromJson(Map<String, dynamic> json) =>
      ConfirmAppPayMomoModel(
        momoToken: json["momoToken"],
        customerNumber: json["customerNumber"],
        description: json["description"],
        partnerCode: json["partnerCode"],
        partnerRefId: json["partnerRefId"],
        amount: json["amount"],
        partnerName: json["partnerName"],
        partnerTransId: json["partnerTransId"],
        storeId: json["storeId"],
        storeName: json["storeName"],
      );

  Map<String, dynamic> toJson() => {
        "momoToken": momoToken,
        "customerNumber": customerNumber,
        "description": description,
        "partnerCode": partnerCode,
        "partnerRefId": partnerRefId,
        "amount": amount,
        "partnerName": partnerName,
        "partnerTransId": partnerTransId,
        "storeId": storeId,
        "storeName": storeName,
      };
}
