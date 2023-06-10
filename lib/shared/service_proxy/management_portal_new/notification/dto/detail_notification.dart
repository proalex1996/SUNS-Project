// class DetailNotificationModel {
//   DetailNotificationModel({
//     this.id,
//     this.title,
//     this.message,
//     this.content,
//     this.isRead,
//     this.type,
//     this.createdTime,
//     this.severity,
//     this.dataExtensionType,
//     this.dataExtension,
//   });

//   String id;
//   String title;
//   String message;
//   dynamic content;
//   bool isRead;
//   String type;
//   DateTime createdTime;
//   int severity;
//   dynamic dataExtensionType;
//   dynamic dataExtension;

//   factory DetailNotificationModel.fromJson(Map<String, dynamic> json) =>
//       DetailNotificationModel(
//         id: json["id"],
//         title: json["title"],
//         message: json["message"],
//         content: json["content"],
//         isRead: json["isRead"],
//         type: json["type"],
//         createdTime: DateTime.parse(json["createdTime"]),
//         severity: json["severity"],
//         dataExtensionType: json["dataExtensionType"],
//         dataExtension: json["dataExtension"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "message": message,
//         "content": content,
//         "isRead": isRead,
//         "type": type,
//         "createdTime": createdTime.toIso8601String(),
//         "severity": severity,
//         "dataExtensionType": dataExtensionType,
//         "dataExtension": dataExtension,
//       };
// }

class DetailNotificationModel {
  DetailNotificationModel({
    this.id,
    this.title,
    this.message,
    this.content,
    this.isRead,
    this.type,
    this.createdTime,
    this.severity,
    this.dataExtensionType,
    this.dataExtension,
  });

  String id;
  String title;
  String message;
  dynamic content;
  bool isRead;
  String type;
  DateTime createdTime;
  int severity;
  String dataExtensionType;
  String dataExtension;

  factory DetailNotificationModel.fromJson(Map<String, dynamic> json) =>
      DetailNotificationModel(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        content: json["content"],
        isRead: json["isRead"],
        type: json["type"],
        createdTime: DateTime.parse(json["createdTime"]),
        severity: json["severity"],
        dataExtensionType: json["dataExtensionType"],
        dataExtension: json["dataExtension"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "content": content,
        "isRead": isRead,
        "type": type,
        "createdTime": createdTime.toIso8601String(),
        "severity": severity,
        "dataExtensionType": dataExtensionType,
        "dataExtension": dataExtension,
      };
}
