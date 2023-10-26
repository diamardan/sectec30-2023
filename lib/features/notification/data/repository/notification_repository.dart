import 'dart:developer';

import 'package:sectec30/config/network/dio_exceptions.dart';
import 'package:sectec30/features/notification/data/api/notification_api.dart';
import 'package:sectec30/features/notification/data/models/device.dart';
import 'package:dio/dio.dart';
import 'package:sectec30/features/notification/data/models/notification_detail.dart';
import 'package:sectec30/features/notification/data/models/notifications.dart';

class NotificationRepository {
  final NotificationApi _api;

  NotificationRepository(this._api);

  Future<void> saveDevice(String userId, Device device) async {
    try {
      await _api.saveDevice(userId, device);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }

  Future<List<Notifications>> getAll(String userId) async {
    try {
      final res = await _api.getNotification(userId);

      final resList =
          (res as List).map((e) => Notifications.fromJson(e)).toList();
      return resList;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }

  Future<void> readNotification(String userId, String notificationId) async {
    try {
      await _api.readNotification(userId, notificationId);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
    }
  }

  Future<NotificationDetail> getById(String notificationId) async {
    try {
      final res = await _api.getNotificationById(notificationId);

      return NotificationDetail.fromJson(res);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e);
      log(errorMessage.toString());
      rethrow;
    }
  }
}
