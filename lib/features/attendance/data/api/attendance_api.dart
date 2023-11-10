import 'package:sectec30/config/network/dio_client.dart';

class AttendanceApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AttendanceApi(this._dioClient);

  Future getCalendar(String? idBio) async {
    try {
      final res = await _dioClient.get('/attendance/calendar/$idBio');
      print(res.data);
      return res.data;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
