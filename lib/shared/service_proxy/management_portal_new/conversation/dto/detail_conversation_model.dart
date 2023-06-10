class ConversationMessageModel {
  ConversationMessageModel({
    this.id,
    this.senderId,
    this.name,
    this.image,
    this.content,
    this.createdTime,
  });

  String id;
  int senderId;
  String name;
  String image;
  String content;
  DateTime createdTime;

  factory ConversationMessageModel.fromJson(Map<String, dynamic> json) =>
      ConversationMessageModel(
        id: json["id"],
        senderId: json["senderId"],
        name: json["name"],
        image: json["image"],
        content: json["content"],
        createdTime: DateTime.parse(json["createdTime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "content": content,
        "name": name,
        "image": image,
        "createdTime": createdTime.toIso8601String(),
      };
}