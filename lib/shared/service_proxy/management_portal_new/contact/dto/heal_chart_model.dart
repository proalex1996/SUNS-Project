class HealthChartModel {
  HealthChartModel({
    this.height,
    this.weight,
    this.bloodGlucose,
    this.systolicBloodPressure,
    this.diastolicBloodPressure,
    this.createdTime,
  });

  int height;
  int weight;
  dynamic bloodGlucose;
  int systolicBloodPressure;
  int diastolicBloodPressure;
  DateTime createdTime;

  factory HealthChartModel.fromJson(Map<String, dynamic> json) =>
      HealthChartModel(
        height: json["height"],
        weight: json["weight"],
        bloodGlucose: json["bloodGlucose"],
        systolicBloodPressure: json["systolicBloodPressure"],
        diastolicBloodPressure: json["diastolicBloodPressure"],
        createdTime: DateTime.parse(json["createdTime"]),
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "weight": weight,
        "bloodGlucose": bloodGlucose,
        "systolicBloodPressure": systolicBloodPressure,
        "diastolicBloodPressure": diastolicBloodPressure,
        "createdTime": createdTime.toIso8601String(),
      };
}
