class DetailDHCModel {
  DetailDHCModel({
    this.id,
    this.name,
    this.phone,
    this.hotline,
    this.address,
    this.email,
    this.introInfo,
    this.logoImage,
    this.introImage,
    this.workingTime,
    this.isSpecialized,
    this.specialized,
    this.rating,
    this.totalRating,
    this.latitude,
    this.longitude,
    this.totalLike,
  });

  String id;
  String name;
  String phone;
  String hotline;
  String address;
  String email;
  String introInfo;
  String logoImage;
  String introImage;
  String workingTime;
  bool isSpecialized;
  String specialized;
  double rating;
  int totalRating;
  double latitude;
  double longitude;
  int totalLike;

  factory DetailDHCModel.fromJson(Map<String, dynamic> json) => DetailDHCModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        hotline: json["hotline"],
        address: json["address"],
        email: json["email"],
        introInfo: json["introInfo"],
        logoImage: json["logoImage"],
        introImage: json["introImage"],
        workingTime: json["workingTime"],
        isSpecialized: json["isSpecialized"],
        specialized: json["specialized"],
        rating: json["rating"].toDouble(),
        totalRating: json["totalRating"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        totalLike: json["totalLike"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "hotline": hotline,
        "address": address,
        "email": email,
        "introInfo": introInfo,
        "logoImage": logoImage,
        "introImage": introImage,
        "workingTime": workingTime,
        "isSpecialized": isSpecialized,
        "specialized": specialized,
        "rating": rating,
        "totalRating": totalRating,
        "latitude": latitude,
        "longitude": longitude,
        "totalLike": totalLike,
      };
}
