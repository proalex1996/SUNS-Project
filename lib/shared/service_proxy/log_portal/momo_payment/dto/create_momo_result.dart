class CreateMomoResult {
  CreateMomoResult({
    this.payUrl,
    this.qrCodeUrl,
    this.deeplink,
    this.deeplinkWebInApp,
  });

  String payUrl;
  String qrCodeUrl;
  String deeplink;
  String deeplinkWebInApp;

  factory CreateMomoResult.fromJson(Map<String, dynamic> json) =>
      CreateMomoResult(
        payUrl: json["payUrl"],
        qrCodeUrl: json["qrCodeUrl"],
        deeplink: json["deeplink"],
        deeplinkWebInApp: json["deeplinkWebInApp"],
      );

  Map<String, dynamic> toJson() => {
        "payUrl": payUrl,
        "qrCodeUrl": qrCodeUrl,
        "deeplink": deeplink,
        "deeplinkWebInApp": deeplinkWebInApp,
      };
}
