class MedicalExaminationModel {
  MedicalExaminationModel({
    this.id,
    this.name,
    this.staffId,
    this.staffName,
    this.appointmentCode,
    this.createdTime,
    this.servicePackageId,
    this.servicePackageName,
    this.address,
    this.price,
    this.rating,
  });

  String id;
  String name;
  String staffId;
  String staffName;
  String appointmentCode;
  DateTime createdTime;
  String servicePackageId;
  String servicePackageName;
  String address;
  int price;
  int rating;

  factory MedicalExaminationModel.fromJson(Map<String, dynamic> json) =>
      MedicalExaminationModel(
        id: json["id"],
        name: json["name"],
        staffId: json["staffId"],
        staffName: json["staffName"],
        appointmentCode: json["appointmentCode"],
        createdTime: DateTime.parse(json["createdTime"]),
        servicePackageId: json["servicePackageId"],
        servicePackageName: json["servicePackageName"],
        address: json["address"],
        price: json["price"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "staffId": staffId,
        "staffName": staffName,
        "appointmentCode": appointmentCode,
        "createdTime": createdTime.toIso8601String(),
        "servicePackageId": servicePackageId,
        "servicePackageName": servicePackageName,
        "address": address,
        "price": price,
        "rating": rating,
      };
}
