class ExaminationModel {
  ExaminationModel({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory ExaminationModel.fromJson(Map<String, dynamic> json) =>
      ExaminationModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
