class DistrictModel {
  DistrictModel({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
