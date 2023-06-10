class InputPrintOrdinalNumberModel {
  InputPrintOrdinalNumberModel({
    this.qrCode,
    this.appointmentId,
  });

  String qrCode;
  String appointmentId;

  factory InputPrintOrdinalNumberModel.fromJson(Map<String, dynamic> json) =>
      InputPrintOrdinalNumberModel(
        qrCode: json["qrCode"],
        appointmentId: json["appointmentId"],
      );

  Map<String, dynamic> toJson() => {
        "qrCode": qrCode,
        "appointmentId": appointmentId,
      };
}
