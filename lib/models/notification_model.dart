import 'dart:convert';

List<NotificationModel> notificationModelFromJson(List data) =>
    List<NotificationModel>.from(
        data.map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) =>
    json.encode(data);

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.projectId,
    this.createdAt,
    this.title,
    this.message,
    this.type,
    this.isOpen,
    required this.attachment,
  });

  int id;
  List<int> projectId;
  DateTime? createdAt;
  String? title;
  String? message;
  String? type;
  int? isOpen;
  List<Attachment> attachment;

  factory NotificationModel.fromJson(Map<String, dynamic> map) =>
      NotificationModel(
        id: map['id'] as int,
        projectId: (map['projectId'] as List).map((e) => e as int).toList(),
        createdAt: map['createdAt'] == null
            ? null
            : DateTime.parse(map['createdAt'] as String),
        title: map['title'] as String,
        message: map['message'] as String,
        type: map['type'] as String,
        isOpen: map['abierta'] as int,
        attachment: (map['attachment'] as List)
            .map((e) => Attachment.fromJson((e as Map).map(
                    (k, e) => MapEntry(k as String, e),
                  ))).toList(),
      );

  factory NotificationModel.pnFromJson(Map<String, dynamic> map) =>
      NotificationModel(
        id: int.parse(map["id"]),
        projectId: List<int>.from(
            (json.decode(map["projectId"]) as List).cast<int>().map((x) => x)),
        createdAt: DateTime.parse(map["createdAt"]),
        title: map["title"],
        message: map["message"],
        type: map["type"],
        isOpen: map["abierta"],
        attachment: List<Attachment>.from(
            json.decode(map["attachment"]).map((x) => Attachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "projectId": List<dynamic>.from(projectId.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "title": title,
        "message": message,
        "type": type,
        "isOpen":isOpen,
        "attachment": List<dynamic>.from(attachment.map((x) => x.toJson())),
      };
}

class Attachment {
  Attachment({
    this.id,
    this.payload,
  });

  int? id;
  String? payload;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"] as int,
        payload: json["payload"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payload": payload,
      };
}
