class WorkingTimeModel {
  WorkingTimeModel({
    this.from,
    this.hour,
    this.active,
  });

  DateTime from;
  String hour;
  bool active;

  factory WorkingTimeModel.fromJson(Map<String, dynamic> json) {
    DateTime.parse(json["from"]);
    return WorkingTimeModel(
      from: DateTime.parse(json["from"]),
      hour: json["hour"],
      active: json["active"],
    );
  }

  Map<String, dynamic> toJson() => {
        "from": from.toIso8601String(),
        "hour": hour,
        "active": active,
      };
}
