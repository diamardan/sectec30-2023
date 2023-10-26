import 'package:sectec30/config/constants/constants.dart';
import 'package:sectec30/features/notification/data/models/notifications.dart';
import 'package:sectec30/features/notification/providers/notification_provider.dart';
import 'package:sectec30/utils/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends ConsumerWidget {
  NotificationScreen({super.key});

  final _shimmerLoading = ShimmerLoading();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(notificationProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notificaciones',
          ),
        ),
        body: Container(
            child: (ref.watch(isLoadingNotificationProvider) == true)
                ? _shimmerLoading.buildShimmerContent()
                : ListView.builder(
                    itemCount: data.length,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _createItem(context, index, data[index]);
                    },
                  )));
  }

  Widget _createItem(BuildContext context, index, Notifications notification) {
    final message = notification.notification!.message!;
    final isRead = notification.read!;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        context.pushNamed('notification-detail',
            extra: notification.notification?.id);
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isRead
                        ? Text(notification.notification!.title!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: softGrey))
                        : Text(notification.notification!.title!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: black21)),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(notification.notification!.sentDate!),
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 11)),
                    /*const SizedBox(
                      height: 8,
                    ),
                    Text(
                        message.length > 100
                            ? '${message.substring(0, 100)}...'
                            : message,
                        style: const TextStyle(color: blackGrey)),*/
                  ],
                )),
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
