class DayOffModel {
  DayOffModel({
    this.dayOffs,
    this.to,
  });

  List<DateTime> dayOffs;
  DateTime to;

  factory DayOffModel.fromJson(Map<String, dynamic> json) => DayOffModel(
        dayOffs:
            List<DateTime>.from(json["dayOffs"].map((x) => DateTime.parse(x))),
        to: DateTime.parse(json["to"]),
      );

  Map<String, dynamic> toJson() => {
        "dayOffs": List<dynamic>.from(dayOffs.map((x) => x.toIso8601String())),
        "to": to.toIso8601String(),
      };
}
