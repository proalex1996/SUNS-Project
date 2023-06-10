class DoctorCheckModel {
  DoctorCheckModel({
    this.id,
    this.name,
    this.image,
    this.address,
    this.isSpecialized,
    this.specialized,
    this.rating,
    this.type,
    this.totalLike,
  });

  String id;
  String name;
  String image;
  String address;
  bool isSpecialized;
  String specialized;
  double rating;
  int type;
  int totalLike;

  factory DoctorCheckModel.fromJson(Map<String, dynamic> json) =>
      DoctorCheckModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        address: json["address"],
        isSpecialized: json["isSpecialized"],
        specialized: json["specialized"],
        rating: json["rating"].toDouble(),
        type: json["type"],
        totalLike: json["totalLike"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "address": address,
        "isSpecialized": isSpecialized,
        "specialized": specialized,
        "rating": rating,
        "type": type,
        "totalLike": totalLike,
      };
}
