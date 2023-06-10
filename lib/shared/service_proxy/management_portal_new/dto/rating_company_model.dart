class RatingOfCompanyModel {
  RatingOfCompanyModel({
    this.id,
    this.userId,
    this.rating,
    this.comment,
    this.createdTime,
  });

  String id;
  int userId;
  int rating;
  String comment;
  DateTime createdTime;

  factory RatingOfCompanyModel.fromJson(Map<String, dynamic> json) =>
      RatingOfCompanyModel(
        id: json["id"],
        userId: json["userId"],
        rating: json["rating"],
        comment: json["comment"],
        createdTime: DateTime.parse(json["createdTime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "rating": rating,
        "comment": comment,
        "createdTime": createdTime.toIso8601String(),
      };
}
