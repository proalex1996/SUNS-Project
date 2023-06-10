class QrModel {
  QrModel({
    this.qrCode,
  });

  String qrCode;

  factory QrModel.fromJson(Map<String, dynamic> json) => QrModel(
        qrCode: json["qrCode"],
      );

  Map<String, dynamic> toJson() => {
        "qrCode": qrCode,
      };
}
