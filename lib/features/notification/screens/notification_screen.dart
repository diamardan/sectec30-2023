import 'package:sectec30/config/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends ConsumerWidget {
  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final data = ref.watch(notificationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notificaciones',
        ),
      ),
      body: Center(
          child:
              Text('Sin notificaciones', style: TextStyle(color: blackGrey))),
    );
  }
}
