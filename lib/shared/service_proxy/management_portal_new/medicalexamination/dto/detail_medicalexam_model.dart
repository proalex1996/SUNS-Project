class DetailMedicalExaminationModel {
  DetailMedicalExaminationModel({
    this.id,
    this.name,
    this.patientName,
    this.staffAddress,
    this.staffId,
    this.staffName,
    this.prescriptions,
    this.appointmentCode,
    this.price,
    this.special,
    this.rating,
    this.comment,
    this.createdTime,
    this.height,
    this.weight,
    this.bloodGroup,
    this.bloodGlucose,
    this.heartbeat,
    this.systolicBloodPressure,
    this.diastolicBloodPressure,
    this.bodyTemperature,
    this.breathingRate,
  });

  String id;
  String name;
  String patientName;
  String staffAddress;
  String staffId;
  String staffName;
  String prescriptions;
  String appointmentCode;
  int price;
  bool special;
  int rating;
  String comment;
  DateTime createdTime;
  int height;
  int weight;
  int bloodGroup;
  int bloodGlucose;
  int heartbeat;
  int systolicBloodPressure;
  int diastolicBloodPressure;
  int bodyTemperature;
  int breathingRate;

  factory DetailMedicalExaminationModel.fromJson(Map<String, dynamic> json) =>
      DetailMedicalExaminationModel(
        id: json["id"],
        name: json["name"],
        patientName: json["patientName"],
        staffAddress: json["staffAddress"],
        staffId: json["staffId"],
        staffName: json["staffName"],
        prescriptions: json["prescriptions"],
        appointmentCode: json["appointmentCode"],
        price: json["price"],
        special: json["special"],
        rating: json["rating"],
        comment: json["comment"],
        createdTime: DateTime.parse(json["createdTime"]),
        height: json["height"],
        weight: json["weight"],
        bloodGroup: json["bloodGroup"],
        bloodGlucose: json["bloodGlucose"],
        heartbeat: json["heartbeat"],
        systolicBloodPressure: json["systolicBloodPressure"],
        diastolicBloodPressure: json["diastolicBloodPressure"],
        bodyTemperature: json["bodyTemperature"],
        breathingRate: json["breathingRate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "patientName": patientName,
        "staffAddress": staffAddress,
        "staffId": staffId,
        "staffName": staffName,
        "prescriptions": prescriptions,
        "appointmentCode": appointmentCode,
        "price": price,
        "special": special,
        "rating": rating,
        "comment": comment,
        "createdTime": createdTime.toIso8601String(),
        "height": height,
        "weight": weight,
        "bloodGroup": bloodGroup,
        "bloodGlucose": bloodGlucose,
        "heartbeat": heartbeat,
        "systolicBloodPressure": systolicBloodPressure,
        "diastolicBloodPressure": diastolicBloodPressure,
        "bodyTemperature": bodyTemperature,
        "breathingRate": breathingRate,
      };
}
