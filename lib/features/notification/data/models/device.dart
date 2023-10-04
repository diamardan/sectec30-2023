// To parse this JSON data, do
//
//     final device = deviceFromJson(jsonString);

import 'dart:convert';

Device deviceFromJson(String str) => Device.fromJson(json.decode(str));

String deviceToJson(Device data) => json.encode(data.toJson());

class Device {
  final String? deviceId;
  final String? brand;
  final String? model;
  final String? os;
  final String? version;
  final String? fcmToken;

  Device({
    this.deviceId,
    this.brand,
    this.model,
    this.os,
    this.version,
    this.fcmToken,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        deviceId: json["deviceId"],
        brand: json["brand"],
        model: json["model"],
        os: json["os"],
        version: json["version"],
        fcmToken: json["fcm_token"],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "brand": brand,
        "model": model,
        "os": os,
        "version": version,
        "fcm_token": fcmToken,
      };
}
