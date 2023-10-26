// To parse this JSON data, do
//
//     final notifications = notificationsFromJson(jsonString);

import 'dart:convert';

Notifications notificationsFromJson(String str) =>
    Notifications.fromJson(json.decode(str));

String notificationsToJson(Notifications data) => json.encode(data.toJson());

class Notifications {
  final String? id;
  final bool? read;
  final Notification? notification;

  Notifications({
    this.id,
    this.read,
    this.notification,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        id: json["id"],
        read: json["read"],
        notification: json["notification"] == null
            ? null
            : Notification.fromJson(json["notification"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "read": read,
        "notification": notification?.toJson(),
      };
}

class Notification {
  final String? id;
  final String? message;
  final String? title;
  final String? origin;
  final bool? haveAttachments;
  final DateTime? sentDate;
  final DateTime? receivedDate;
  final String? inputMode;

  Notification({
    this.id,
    this.message,
    this.title,
    this.origin,
    this.haveAttachments,
    this.sentDate,
    this.receivedDate,
    this.inputMode,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"],
        message: json["message"],
        title: json["title"],
        origin: json["origin"],
        haveAttachments: json["have_attachments"],
        sentDate: json["sent_date"] == null
            ? null
            : DateTime.parse(json["sent_date"]),
        receivedDate: json["received_date"] == null
            ? null
            : DateTime.parse(json["received_date"]),
        inputMode: json["input_mode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "title": title,
        "origin": origin,
        "have_attachments": haveAttachments,
        "sent_date": sentDate?.toIso8601String(),
        "received_date": receivedDate?.toIso8601String(),
        "input_mode": inputMode,
      };
}
