import 'dart:convert';

import 'package:sectec30/config/shared_provider/shared_providers.dart';
import 'package:sectec30/features/notification/data/api/notification_api.dart';
import 'package:sectec30/features/notification/data/models/device.dart';
import 'package:sectec30/features/notification/data/models/notification_detail.dart';
import 'package:sectec30/features/notification/data/repository/notification_repository.dart';
import 'package:sectec30/utils/key_value_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sectec30/features/notification/data/models/notifications.dart';
import 'package:flutter/material.dart';

final notificationApiProvider = Provider<NotificationApi>((ref) {
  return NotificationApi(ref.read(dioClientProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.read(notificationApiProvider));
});

final notificationProvider = StateNotifierProvider.autoDispose<
    NotificationNotifier, List<Notifications>>((ref) {
  return NotificationNotifier(ref: ref);
});

final isLoadingNotificationProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final notificationDetailProvider = FutureProvider.family
    .autoDispose<NotificationDetail, String>((ref, notificationId) async {
  return await ref.read(notificationRepositoryProvider).getById(notificationId);
});

final readNotificacionProvider =
    StateProvider.family.autoDispose<void, String>((ref, notificationId) async {
  final keyValueStorageService = KeyValueStorageServiceImpl();
  final userId = await keyValueStorageService.getValue<String>('userId');
  await ref
      .read(notificationRepositoryProvider)
      .readNotification(userId!, notificationId);
});

class NotificationNotifier extends StateNotifier<List<Notifications>> {
  // Fetching all products whenever anyone starts listning.
  // Passing Ref, in order to access other providers inside this.
  NotificationNotifier({required this.ref}) : super([]) {
    fetchProducts(ref: ref);
  }
  final Ref ref;

  Future fetchProducts({required Ref ref}) async {
    final keyValueStorageService = KeyValueStorageServiceImpl();
    final userId = await keyValueStorageService.getValue<String>('userId');
    await ref
        .read(notificationRepositoryProvider)
        .getAll(userId!)
        .then((value) {
      state = value;
      // Setting isLoading to `false`.
      ref.read(isLoadingNotificationProvider.notifier).state = false;
    });
  }
}

final saveTokenDeviceProvider = Provider<void>((ref) async {
  final keyValueStorageService = KeyValueStorageServiceImpl();
  final userId = await keyValueStorageService.getValue<String>('userId');
  final deviceIn =
      await keyValueStorageService.getValue<String>('info.deviceId');
  final devicebrand =
      await keyValueStorageService.getValue<String>('info.brand');
  final deviceModel =
      await keyValueStorageService.getValue<String>('info.model');
  final deviceOs = await keyValueStorageService.getValue<String>('info.os');
  final deviceVersion =
      await keyValueStorageService.getValue<String>('info.version');
  final fcm = await keyValueStorageService.getValue<String>('fcm');

  Map<String, dynamic> device = {
    "deviceId": deviceIn,
    "brand": devicebrand,
    "model": deviceModel,
    "os": deviceOs,
    "version": deviceVersion,
    "fcm_token": fcm
  };

  await ref
      .read(notificationRepositoryProvider)
      .saveDevice(userId!, Device.fromJson(device));
});
