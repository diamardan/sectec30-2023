import 'package:sectec30/config/network/dio_client.dart';
import 'package:sectec30/features/notification/data/models/device.dart';

class NotificationApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  NotificationApi(this._dioClient);

  Future saveDevice(String userId, Device device) async {
    try {
      final res = await _dioClient.post('/devices/addToUser/$userId',
          data: device.toJson());
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future getNotification(String userId) async {
    try {
      final res = await _dioClient.get('/notifications/$userId');
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future readNotification(String userId, String notificationId) async {
    try {
      final res = await _dioClient
          .put('/notifications/$notificationId/mark-as-read/$userId');
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future getNotificationById(String notificationId) async {
    try {
      final res = await _dioClient.get('/notifications/view/$notificationId');
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
