class BanchModel {
  BanchModel({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory BanchModel.fromJson(Map<String, dynamic> json) => BanchModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
