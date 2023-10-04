import 'dart:convert';

import 'package:sectec30/config/shared_provider/shared_providers.dart';
import 'package:sectec30/features/notification/data/api/notification_api.dart';
import 'package:sectec30/features/notification/data/models/device.dart';
import 'package:sectec30/features/notification/data/repository/notification_repository.dart';
import 'package:sectec30/utils/key_value_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationApiProvider = Provider<NotificationApi>((ref) {
  return NotificationApi(ref.read(dioClientProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.read(notificationApiProvider));
});

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
