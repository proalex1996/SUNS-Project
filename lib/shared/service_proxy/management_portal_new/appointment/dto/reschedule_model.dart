class RescheduleModel {
  RescheduleModel({
    this.appointmentTime,
    this.staffId,
  });

  DateTime appointmentTime;
  String staffId;

  factory RescheduleModel.fromJson(Map<String, dynamic> json) =>
      RescheduleModel(
        appointmentTime: DateTime.parse(json["appointmentTime"]),
        staffId: json["staffId"],
      );

  Map<String, dynamic> toJson() => {
        "appointmentTime": appointmentTime.toIso8601String(),
        "staffId": staffId,
      };
}
