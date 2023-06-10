class NotificationModel {
  NotificationModel({
    this.severity,
    this.dataExtension,
    this.name,
    this.createdTime,
    this.description,
    this.id,
    this.shortDescription,
    this.dataExtensionType,
    this.notificationDefinitionCode,
  });

  int severity;
  String dataExtension;
  String name;
  DateTime createdTime;
  dynamic description;
  String id;
  String shortDescription;
  String dataExtensionType;
  String notificationDefinitionCode;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      severity: json["severity"],
      dataExtension: json["dataExtension"],
      name: json["name"],
      createdTime: DateTime.parse(json["createdTime"]),
      description: json["description"],
      id: json["id"],
      shortDescription: json["shortDescription"],
      dataExtensionType: json["dataExtensionType"],
      notificationDefinitionCode: json["notificationDefinitionCode"],
    );
  }

  Map<String, dynamic> toJson() => {
        "severity": severity,
        "dataExtension": dataExtension,
        "name": name,
        "createdTime": createdTime.toIso8601String(),
        "description": description,
        "id": id,
        "shortDescription": shortDescription,
        "dataExtensionType": dataExtensionType,
        "notificationDefinitionCode": notificationDefinitionCode,
      };
}

class NotifyModel {
  NotifyModel({
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

  factory NotifyModel.fromJson(Map<String, dynamic> json) => NotifyModel(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        content: json["content"],
        isRead: json["isRead"],
        type: json["type"],
        createdTime: DateTime.parse(json["createdTime"]),
        severity: json["severity"],
        dataExtensionType: json["dataExtensionType"] == null
            ? null
            : json["dataExtensionType"],
        dataExtension:
            json["dataExtension"] == null ? null : json["dataExtension"],
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
        "dataExtensionType":
            dataExtensionType == null ? null : dataExtensionType,
        "dataExtension": dataExtension == null ? null : dataExtension,
      };
}

class NotificationAppointmentRejectData {
  NotificationAppointmentRejectData({
    this.companyId,
    this.type,
    this.reason,
  });

  String companyId;
  int type;
  String reason;

  factory NotificationAppointmentRejectData.fromJson(
          Map<String, dynamic> json) =>
      NotificationAppointmentRejectData(
        companyId: json["companyId"],
        type: json["type"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "type": type,
        "reason": reason,
      };
}

class NotificationAppointmentRemindData {
  NotificationAppointmentRemindData({
    this.companyId,
    this.type,
    this.appointmentDate,
    this.isAppointmentDateTime,
  });

  String companyId;
  int type;
  DateTime appointmentDate;
  bool isAppointmentDateTime;

  factory NotificationAppointmentRemindData.fromJson(
          Map<String, dynamic> json) =>
      NotificationAppointmentRemindData(
        companyId: json["companyId"],
        type: json["type"],
        appointmentDate: DateTime.parse(json["appointmentDate"]),
        isAppointmentDateTime: json["isAppointmentDateTime"],
      );

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "type": type,
        "appointmentDate": appointmentDate.toIso8601String(),
        "isAppointmentDateTime": isAppointmentDateTime,
      };
}

// class NotifyModel {
//   NotifyModel({
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
//   Type type;
//   DateTime createdTime;
//   int severity;
//   DataExtensionType dataExtensionType;
//   String dataExtension;

//   factory NotifyModel.fromJson(Map<String, dynamic> json) => NotifyModel(
//         id: json["id"],
//         title: json["title"],
//         message: json["message"],
//         content: json["content"],
//         isRead: json["isRead"],
//         type: typeValues.map[json["type"]],
//         createdTime: DateTime.parse(json["createdTime"]),
//         severity: json["severity"],
//         dataExtensionType:
//             dataExtensionTypeValues.map[json["dataExtensionType"]],
//         dataExtension: json["dataExtension"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": titleValues.reverse[title],
//         "message": message,
//         "content": content,
//         "isRead": isRead,
//         "type": typeValues.reverse[type],
//         "createdTime": createdTime.toIso8601String(),
//         "severity": severity,
//         "dataExtensionType": dataExtensionTypeValues.reverse[dataExtensionType],
//         "dataExtension": dataExtension,
//       };
// }

// enum DataExtensionType {
//   NOTIFICATION_APPOINTMENT_REJECT_DATA,
//   NOTIFICATION_APPOINTMENT_DATA
// }

// final dataExtensionTypeValues = EnumValues({
//   "NotificationAppointmentData":
//       DataExtensionType.NOTIFICATION_APPOINTMENT_DATA,
//   "NotificationAppointmentRejectData":
//       DataExtensionType.NOTIFICATION_APPOINTMENT_REJECT_DATA
// });

// enum Title { THNG_BO_HY_LCH, THNG_BO_T_LCH_HN_THNH_CNG, THNG_BO_XC_NHN_LCH_HN }

// final titleValues = EnumValues({
//   "Thông báo hủy lịch": Title.THNG_BO_HY_LCH,
//   "Thông báo đặt lịch hẹn thành công": Title.THNG_BO_T_LCH_HN_THNH_CNG,
//   "Thông báo xác nhận lịch hẹn": Title.THNG_BO_XC_NHN_LCH_HN
// });

// enum Type {
//   NOTIFY_APPOINTMENT_REQUEST_REJECT,
//   NOTIFY_APPOINTMENT_APPOINTMENT_CREATED,
//   APPOINTMENT_APPROVED
// }

// final typeValues = EnumValues({
//   "AppointmentApproved": Type.APPOINTMENT_APPROVED,
//   "Notify.Appointment.AppointmentCreated":
//       Type.NOTIFY_APPOINTMENT_APPOINTMENT_CREATED,
//   "Notify.Appointment.Request.Reject": Type.NOTIFY_APPOINTMENT_REQUEST_REJECT
// });

// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
