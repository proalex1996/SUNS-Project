class ClinicBranchModel {
  ClinicBranchModel({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory ClinicBranchModel.fromJson(Map<String, dynamic> json) =>
      ClinicBranchModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
