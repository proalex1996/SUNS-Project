class CreateDeviceTokenInput {
  CreateDeviceTokenInput({
    this.deviceToken,
    this.appId,
    this.actived,
  });

  String deviceToken;
  String appId;
  bool actived;

  factory CreateDeviceTokenInput.fromJson(Map<String, dynamic> json) =>
      CreateDeviceTokenInput(
        deviceToken: json["deviceToken"],
        appId: json["appId"],
        actived: json["actived"],
      );

  Map<String, dynamic> toJson() => {
        "deviceToken": deviceToken,
        "appId": appId,
        "actived": actived,
      };
}
