class UserSupportModel {
  UserSupportModel({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory UserSupportModel.fromJson(Map<String, dynamic> json) =>
      UserSupportModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
