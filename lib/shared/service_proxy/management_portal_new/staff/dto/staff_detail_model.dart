class StaffDetailModel {
  StaffDetailModel({
    this.id,
    this.userId,
    this.name,
    this.speciallizeId,
    this.specializeName,
    this.branchId,
    this.branchName,
    this.rating,
    this.description,
    this.image,
  });

  String id;
  int userId;
  String name;
  String speciallizeId;
  String specializeName;
  String branchId;
  String branchName;
  double rating;
  String description;
  String image;

  factory StaffDetailModel.fromJson(Map<String, dynamic> json) =>
      StaffDetailModel(
        id: json["id"],
        userId: json["userId"],
        name: json["name"],
        speciallizeId: json["speciallizeId"],
        specializeName: json["specializeName"],
        branchId: json["branchId"],
        branchName: json["branchName"],
        rating: json["rating"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "speciallizeId": speciallizeId,
        "specializeName": specializeName,
        "branchId": branchId,
        "branchName": branchName,
        "rating": rating,
        "description": description,
        "image": image,
      };
}
