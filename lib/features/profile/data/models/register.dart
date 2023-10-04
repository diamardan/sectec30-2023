// To parse this JSON data, do
//
//     final registerInfo = registerInfoFromJson(jsonString);

import 'dart:convert';

RegisterInfo registerInfoFromJson(String str) =>
    RegisterInfo.fromJson(json.decode(str));

String registerInfoToJson(RegisterInfo data) => json.encode(data.toJson());

class RegisterInfo {
  final Registration registration;

  RegisterInfo({
    required this.registration,
  });

  factory RegisterInfo.fromJson(Map<String, dynamic> json) => RegisterInfo(
        registration: Registration.fromJson(json["registration"]),
      );

  Map<String, dynamic> toJson() => {
        "registration": registration.toJson(),
      };
}

class Registration {
  final String? id;
  final String? names;
  final String? surnames;
  final String? curp;
  final String? email;
  final String? cellphone;
  final String? idbio;
  final String? registrationType;
  final String? registrationNumber;
  final String? studentSignaturePath;
  final String? studentPhotoPath;
  final String? studentQrPath;
  final String? studentVoucherPath;
  final String? qr;
  final DateTime? creationDate;
  final DateTime? updateDate;
  final String? fecha;
  final String? hora;
  final String? tipoRegistro;
  final int? idbioInt;
  final Career? career;
  final Career? grade;
  final Career? group;
  final Career? turn;

  Registration({
    this.id,
    this.names,
    this.surnames,
    this.curp,
    this.email,
    this.cellphone,
    this.idbio,
    this.registrationType,
    this.registrationNumber,
    this.studentSignaturePath,
    this.studentPhotoPath,
    this.studentQrPath,
    this.studentVoucherPath,
    this.qr,
    this.creationDate,
    this.updateDate,
    this.fecha,
    this.hora,
    this.tipoRegistro,
    this.idbioInt,
    this.career,
    this.grade,
    this.group,
    this.turn,
  });

  factory Registration.fromJson(Map<String, dynamic> json) => Registration(
        id: json["id"],
        names: json["names"],
        surnames: json["surnames"],
        curp: json["curp"],
        email: json["email"],
        cellphone: json["cellphone"],
        idbio: json["idbio"],
        registrationType: json["registration_type"],
        registrationNumber: json["registration_number"],
        studentSignaturePath: json["student_signature_path"],
        studentPhotoPath: json["student_photo_path"],
        studentQrPath: json["student_qr_path"],
        studentVoucherPath: json["student_voucher_path"],
        qr: json["qr"],
        creationDate: json["creation_date"] == null
            ? null
            : DateTime.parse(json["creation_date"]),
        updateDate: json["update_date"] == null
            ? null
            : DateTime.parse(json["update_date"]),
        fecha: json["fecha"],
        hora: json["hora"],
        tipoRegistro: json["tipo_registro"],
        idbioInt: json["idbioInt"],
        career: json["career"] == null ? null : Career.fromJson(json["career"]),
        grade: json["grade"] == null ? null : Career.fromJson(json["grade"]),
        group: json["group"] == null ? null : Career.fromJson(json["group"]),
        turn: json["turn"] == null ? null : Career.fromJson(json["turn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "names": names,
        "surnames": surnames,
        "curp": curp,
        "email": email,
        "cellphone": cellphone,
        "idbio": idbio,
        "registration_type": registrationType,
        "registration_number": registrationNumber,
        "student_signature_path": studentSignaturePath,
        "student_photo_path": studentPhotoPath,
        "student_qr_path": studentQrPath,
        "student_voucher_path": studentVoucherPath,
        "qr": qr,
        "creation_date": creationDate?.toIso8601String(),
        "update_date": updateDate?.toIso8601String(),
        "fecha": fecha,
        "hora": hora,
        "tipo_registro": tipoRegistro,
        "idbioInt": idbioInt,
        "career": career?.toJson(),
        "grade": grade?.toJson(),
        "group": group?.toJson(),
        "turn": turn?.toJson(),
      };
}

class Career {
  final String? id;
  final String? name;
  final int? position;

  Career({
    this.id,
    this.name,
    this.position,
  });

  factory Career.fromJson(Map<String, dynamic> json) => Career(
        id: json["id"],
        name: json["name"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "position": position,
      };
}
