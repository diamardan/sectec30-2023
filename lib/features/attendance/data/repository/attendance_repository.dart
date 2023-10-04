import 'dart:developer';

import 'package:sectec30/config/network/dio_exceptions.dart';
import 'package:sectec30/features/attendance/data/api/attendance_api.dart';
import 'package:sectec30/features/attendance/data/models/calendar_attendances.dart';
import 'package:dio/dio.dart';

class AttendanceRepository {
  final AttendanceApi _api;

  AttendanceRepository(this._api);
  // TODO - Desconectar y usar tu modelo Presence, es necesairo crearlo en quicktype
  Future<List<CalendarAttendance>> getCalendar(String? idbio) async {
    try {
      final res = await _api.getCalendar(idbio);
      final resList =
          (res as List).map((e) => CalendarAttendance.fromMap(e)).toList();
      print(resList);
      return resList;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      print(errorMessage.toString());
      log(errorMessage.toString());
      rethrow;
    }
  }
}
