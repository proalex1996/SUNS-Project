class WardModel {
  WardModel({
    this.id,
    this.name,
    this.code,
  });

  String id;
  String name;
  String code;

  factory WardModel.fromJson(Map<String, dynamic> json) => WardModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
      };
}
