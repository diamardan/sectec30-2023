import 'dart:developer';

import 'package:sectec30/config/network/dio_exceptions.dart';
import 'package:sectec30/features/profile/data/api/profile_api.dart';
import 'package:sectec30/features/profile/data/models/register.dart';
import 'package:dio/dio.dart';

class ProfileRepository {
  final ProfileApi _api;

  ProfileRepository(this._api);

  Future<Registration> profile(String curp) async {
    try {
      final res = await _api.profile(curp);
      if (res == "") return Registration();
      return RegisterInfo.fromJson(res).registration;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }
}
