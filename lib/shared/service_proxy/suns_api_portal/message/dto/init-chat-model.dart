class InitChatModel {
    InitChatModel({
        this.id,
        this.senderId,
        this.receiverId,
        this.content,
        this.createdTime,
    });

    String id;
    int senderId;
    int receiverId;
    String content;
    DateTime createdTime;

    factory InitChatModel.fromJson(Map<String, dynamic> json) => InitChatModel(
        id: json["id"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        content: json["content"],
        createdTime: DateTime.parse(json["createdTime"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "content": content,
        "createdTime": createdTime.toIso8601String(),
    };
}
