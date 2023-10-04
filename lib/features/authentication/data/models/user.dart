// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String? authToken;
  final String? id;
  final String? email;
  final String? username;
  final String? password;
  final String? fullName;
  final bool? isActive;
  final String? curp;
  final String? qr;
  final List<String>? roles;
  final int? maxDevicesAllowed;
  final List<dynamic>? devices;

  User({
    this.authToken,
    this.id,
    this.email,
    this.username,
    this.password,
    this.fullName,
    this.isActive,
    this.curp,
    this.qr,
    this.roles,
    this.maxDevicesAllowed,
    this.devices,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        authToken: json["auth_token"],
        id: json["id"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        fullName: json["fullName"],
        isActive: json["isActive"],
        curp: json["curp"],
        qr: json["qr"],
        roles: json["roles"] == null
            ? []
            : List<String>.from(json["roles"]!.map((x) => x)),
        maxDevicesAllowed: json["max_devices_allowed"],
        devices: json["devices"] == null
            ? []
            : List<dynamic>.from(json["devices"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "auth_token": authToken,
        "id": id,
        "email": email,
        "username": username,
        "password": password,
        "fullName": fullName,
        "isActive": isActive,
        "curp": curp,
        "qr": qr,
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
        "max_devices_allowed": maxDevicesAllowed,
        "devices":
            devices == null ? [] : List<dynamic>.from(devices!.map((x) => x)),
      };
}
