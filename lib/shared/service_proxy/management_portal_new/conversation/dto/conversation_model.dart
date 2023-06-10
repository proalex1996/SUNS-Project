class ConversationModel {
  ConversationModel({
    this.id,
    this.name,
    this.image,
    this.latestContent,
    this.latestTime,
    this.type,
    this.receiverId,
  });

  String id;
  String name;
  String image;
  String latestContent;
  DateTime latestTime;
  int type;
  int receiverId;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        latestContent: json["latestContent"],
        latestTime: DateTime.parse(json["latestTime"]),
        type: json["type"],
        receiverId: json["receiverId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "latestContent": latestContent,
        "latestTime": latestTime.toIso8601String(),
        "type": type,
        "receiverId": receiverId,
      };
}
