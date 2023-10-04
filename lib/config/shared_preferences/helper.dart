import 'dart:async';

import 'package:sectec30/config/shared_preferences/preferences.dart';

class SharedPreferenceHelper {
  final Preference _sharedPreference;

  const SharedPreferenceHelper(this._sharedPreference);

  // General Methods: ----------------------------------------------------------
  Future<void> saveAuthToken(String authToken) async {
    await _sharedPreference.setString(PrefKeys.authToken, authToken);
  }

  String? get authToken {
    return _sharedPreference.getString(PrefKeys.authToken);
  }

  Future<bool> removeAuthToken() async {
    return _sharedPreference.remove(PrefKeys.authToken);
  }

  Future<void> saveIsLoggedIn(bool value) async {
    await _sharedPreference.setBool(PrefKeys.isLoggedIn, value);
  }

  bool get isLoggedIn {
    return _sharedPreference.getBool(PrefKeys.isLoggedIn) ?? false;
  }

  Future<void> saveUserId(String userId) async {
    await _sharedPreference.setString(PrefKeys.userId, userId);
  }

  String? get userId {
    return _sharedPreference.getString(PrefKeys.userId);
  }

  Future<void> saveDeviceId(String device) async {
    await _sharedPreference.setString(PrefKeys.device, device);
  }

  String? get deviceId {
    return _sharedPreference.getString(PrefKeys.device);
  }

  Future<void> saveCurp(String device) async {
    await _sharedPreference.setString(PrefKeys.curp, device);
  }

  String? get curp {
    return _sharedPreference.getString(PrefKeys.curp);
  }

  Future<void> saveQr(String qr) async {
    await _sharedPreference.setString(PrefKeys.qr, qr);
  }

  String? get qr {
    return _sharedPreference.getString(PrefKeys.qr);
  }

  Future<void> saveDeviceInfo(String deviceInfo) async {
    await _sharedPreference.setString(PrefKeys.deviceInfo, deviceInfo);
  }

  String? get deviceInfo {
    return _sharedPreference.getString(PrefKeys.deviceInfo);
  }

  Future<void> clear() async {
    await _sharedPreference.clear();
  }
}

mixin PrefKeys {
  static const String isLoggedIn = "isLoggedIn";
  static const String authToken = "token";
  static const String userId = "userId";
  static const String device = "deviceId";
  static const String curp = "curp";
  static const String qr = "qr";
  static const String deviceInfo = "deviceInfo";
}
