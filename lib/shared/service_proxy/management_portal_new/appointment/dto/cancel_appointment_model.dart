class CancelAppointmentModel {
  CancelAppointmentModel({
    this.reason,
  });

  String reason;

  factory CancelAppointmentModel.fromJson(Map<String, dynamic> json) =>
      CancelAppointmentModel(
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
      };
}
