import 'dart:convert';

import 'package:sectec30/config/router/app_router.dart';
import 'package:sectec30/config/shared_provider/shared_providers.dart';
import 'package:sectec30/features/notification/data/models/received_notification.dart';
import 'package:sectec30/features/notification/providers/firebase_backgroud_messaging.dart';
import 'package:sectec30/features/notification/providers/firebase_messaging_provider.dart';
import 'package:sectec30/features/notification/providers/local_push_notification_provider.dart';
import 'package:sectec30/utils/key_value_storage_service_impl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebasePushNotificationProvider =
    Provider<FirebasePushNotification>((ref) {
  final messaging = ref.watch(firebaseMessagingProvider);
  final localPushNotification = ref.watch(localPushNotificationProvider);
  return FirebasePushNotification(messaging, localPushNotification, ref);
});

class FirebasePushNotification {
  final FirebaseMessaging messaging;
  final LocalPushNotification _localPushNotification;
  final Ref ref;
  final keyValueStorageService = KeyValueStorageServiceImpl();

  FirebasePushNotification(
      this.messaging, this._localPushNotification, this.ref) {
    _init();
    _onFirebaseMessageReceived();
    _setupInteractedMessage();
  }

  void _init() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      getFCMToken();
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    /**
     * Handling messages whilst your application is in the background is a little different. 
     * Messages can be handled via the onBackgroundMessage handler. When received, 
     * an isolate is spawned (Android only, iOS/macOS does not require a separate isolate) allowing you to 
     * handle messages even when your application is not running.
     */
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void _onFirebaseMessageReceived() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> data = message.data;

      if (notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
        _localPushNotification.showNotification(ReceivedNotification(
            notification.hashCode,
            notification.title,
            notification.body,
            android?.imageUrl,
            jsonEncode(data),
            android?.smallIcon));
      }
    });
  }

  Future<String> getFCMToken() async {
    final token = await messaging
        .getToken(); /* .then((token) {
      print('APNS Token: $token');
    }); */
    String tokenString = token as String;
    print('APNS Token: $tokenString');
    await keyValueStorageService.setKeyValue('fcm', tokenString);
    debugPrint(token);
    return token;
  }

  Future<void> _setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await messaging.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['link'] != null) {
      final link = message.data['link'];
      ref.read(goRouterProvider).push(link);
    }
  }
}
