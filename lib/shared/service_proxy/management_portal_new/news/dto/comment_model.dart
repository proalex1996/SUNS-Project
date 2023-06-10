class CommentModel {
  CommentModel({
    this.description,
  });

  String description;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}
