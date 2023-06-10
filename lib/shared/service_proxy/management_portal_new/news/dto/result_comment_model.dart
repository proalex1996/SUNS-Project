class ResultCommentModel {
  ResultCommentModel({
    this.id,
    this.description,
    this.createdById,
    this.createdTime,
  });

  String id;
  String description;
  int createdById;
  DateTime createdTime;

  factory ResultCommentModel.fromJson(Map<String, dynamic> json) =>
      ResultCommentModel(
        id: json["id"],
        description: json["description"],
        createdById: json["createdById"],
        createdTime: DateTime.parse(json["createdTime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "createdById": createdById,
        "createdTime": createdTime.toIso8601String(),
      };
}
