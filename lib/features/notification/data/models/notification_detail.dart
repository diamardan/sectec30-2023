// To parse this JSON data, do
//
//     final notificationDetail = notificationDetailFromJson(jsonString);

import 'dart:convert';

NotificationDetail notificationDetailFromJson(String str) =>
    NotificationDetail.fromJson(json.decode(str));

String notificationDetailToJson(NotificationDetail data) =>
    json.encode(data.toJson());

class NotificationDetail {
  final String? id;
  final String? message;
  final String? title;
  final String? origin;
  final bool? haveAttachments;
  final DateTime? sentDate;
  final DateTime? receivedDate;
  final String? inputMode;
  final List<Attachment>? attachments;

  NotificationDetail({
    this.id,
    this.message,
    this.title,
    this.origin,
    this.haveAttachments,
    this.sentDate,
    this.receivedDate,
    this.inputMode,
    this.attachments,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) =>
      NotificationDetail(
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
        attachments: json["attachments"] == null
            ? []
            : List<Attachment>.from(
                json["attachments"]!.map((x) => Attachment.fromJson(x))),
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
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
      };
}

class Attachment {
  final String? id;
  final String? filename;
  final String? filepath;
  final String? mimeType;

  Attachment({
    this.id,
    this.filename,
    this.filepath,
    this.mimeType,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        filename: json["filename"],
        filepath: json["filepath"],
        mimeType: json["mimeType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "filename": filename,
        "filepath": filepath,
        "mimeType": mimeType,
      };
}
