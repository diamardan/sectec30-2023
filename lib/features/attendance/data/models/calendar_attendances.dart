import 'dart:convert';

class CalendarAttendance {
  String id_biostar;
  DateTime fecha;
  DateTime entrada;
  DateTime? salida;
  String descripcion;
  String tipo;

  CalendarAttendance({
    required this.id_biostar,
    required this.fecha,
    required this.entrada,
    required this.salida,
    required this.descripcion,
    required this.tipo,
  });

  CalendarAttendance copyWith({
    String? id_biostar,
    DateTime? fecha,
    DateTime? entrada,
    DateTime? salida,
    String? descripcion,
    String? tipo,
  }) =>
      CalendarAttendance(
        id_biostar: id_biostar ?? this.id_biostar,
        fecha: fecha ?? this.fecha,
        entrada: entrada ?? this.entrada,
        salida: salida ?? this.salida,
        descripcion: descripcion ?? this.descripcion,
        tipo: tipo ?? this.tipo,
      );

  factory CalendarAttendance.fromJson(String str) =>
      CalendarAttendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CalendarAttendance.fromMap(Map<String, dynamic> json) {
    final idBiostar = json["id_biostar"];
    final fecha = DateTime.parse(json["fecha"]);
    final entrada = DateTime.parse(json["entrada"]);
    final salida = json["salida"] == "" ? null : DateTime.parse(json["salida"]);
    final descripcion = json["descripcion"];
    final tipo = json["tipo"];

    return CalendarAttendance(
      id_biostar: idBiostar,
      fecha: fecha,
      entrada: entrada,
      salida: salida,
      descripcion: descripcion,
      tipo: tipo,
    );
  }
  Map<String, dynamic> toMap() => {
        "id_biostar": id_biostar,
        "fecha": fecha.toIso8601String(),
        "entrada": entrada.toIso8601String(),
        "salida": salida != null ? salida!.toIso8601String() : null,
        "descripcion": descripcion,
        "tipo": tipo,
      };
}
