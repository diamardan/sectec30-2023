import 'dart:convert';

import 'package:sectec30/config/router/app_router.dart';
import 'package:sectec30/features/notification/data/models/received_notification.dart';
import 'package:sectec30/features/notification/providers/flutter_local_notification_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localPushNotificationProvider = Provider<LocalPushNotification>((ref) {
  final localNotificationPlugin = ref.watch(flutterLocalNotificationProvider);
  return LocalPushNotification(localNotificationPlugin, ref);
});

class LocalPushNotification {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final Ref ref;

  LocalPushNotification(this._localNotificationsPlugin, this.ref) {
    _init();
  }
  void _init() async {
    const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(requestAlertPermission: true));

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_notificationChannelMax());

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint(details.toString());
        _handleMessage(details.payload);
      },
      /*onDidReceiveBackgroundNotificationResponse: (details) {
        debugPrint(details.toString());
      },*/
    );
  }

  /// On Android, notification messages are sent to Notification Channels which are used to control how a notification is delivered.
  /// The default FCM channel used is hidden from users, however provides a "default" importance level.
  /// Heads up notifications require a "max" importance level.
  void showNotification(ReceivedNotification message) async {
    //final String largeIcon = await _base64EncodeImage(message.imageUrl ?? '');
    final String bigPicture = await _base64EncodeImage(message.imageUrl ?? '');
    await _localNotificationsPlugin.show(
        message.id,
        message.title,
        message.body,
        NotificationDetails(
            android: _androidNotificationDetails(message.smallIcon),
            iOS: const DarwinNotificationDetails()),
        payload: message.payload);
  }

  Future<String> _base64EncodeImage(String urlImage) async {
    if (urlImage.isEmpty) return base64Encode([]);
    final response = await Dio().get<List<int>>(urlImage,
        options: Options(responseType: ResponseType.bytes));
    final String base64Data = base64Encode(response.data ?? []);
    return base64Data;
  }

  AndroidNotificationDetails _androidNotificationDetails(String? smallIcon) {
    return AndroidNotificationDetails('1001', 'General Notification',
        importance: Importance.max,
        priority: Priority.max,
        channelDescription: 'This is general notification channel',
        channelShowBadge: true,
        icon: smallIcon);
  }

  AndroidNotificationChannel _notificationChannelMax() {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    return channel;
  }

  void _handleMessage(String? payload) {
    final Map<String, dynamic> data = jsonDecode(payload ?? '');
    if (data['link'] != null) {
      final link = data['link'];
      ref.read(goRouterProvider).push(link);
    }
  }
}
