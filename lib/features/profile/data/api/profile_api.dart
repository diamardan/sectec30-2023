import 'package:sectec30/config/network/dio_client.dart';

class ProfileApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  ProfileApi(this._dioClient);

  Future profile(String curp) async {
    try {
      final res = await _dioClient
          .post('/auth/check-registration', data: {"curp": curp});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
