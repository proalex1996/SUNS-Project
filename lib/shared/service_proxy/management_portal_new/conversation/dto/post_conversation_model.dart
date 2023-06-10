class CreateConversationMessageInput {
  CreateConversationMessageInput({
    this.content,
  });

  String content;

  factory CreateConversationMessageInput.fromJson(Map<String, dynamic> json) =>
      CreateConversationMessageInput(
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
      };
}

class CreateConversationInput {
  CreateConversationInput({
    this.userIds,
    this.type,
    this.name,
  });

  List<int> userIds;
  int type;
  String name;

  factory CreateConversationInput.fromJson(Map<String, dynamic> json) =>
      CreateConversationInput(
        userIds: List<int>.from(json["userIds"].map((x) => x)),
        type: json["type"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "userIds": List<dynamic>.from(userIds.map((x) => x)),
        "type": type,
        "name": name,
      };
}
