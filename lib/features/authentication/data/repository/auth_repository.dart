import 'package:sectec30/config/network/dio_exceptions.dart';
import 'package:sectec30/features/authentication/data/api/auth_api.dart';
import 'package:sectec30/features/authentication/data/models/user.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final AuthApi _authApi;

  AuthRepository(this._authApi);

  Future<User> loginWithQr(String qr) async {
    try {
      final res = await _authApi.loginWithQr(qr);
      return User.fromJson(res);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      throw errorMessage.message;
    }
  }

  Future<User> loginWithCredentials(String email, String password) async {
    try {
      final res = await _authApi.loginWithCredentials(email, password);
      return User.fromJson(res);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      throw errorMessage.message;
    }
  }
}
