import 'package:sectec30/config/constants/constants.dart';
import 'package:sectec30/config/constants/environment.dart';
import 'package:sectec30/features/notification/data/models/notification_detail.dart';
import 'package:sectec30/features/notification/providers/notification_provider.dart';
import 'package:sectec30/utils/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const NotificationDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends ConsumerState<NotificationDetailScreen> {
  final _shimmerLoading = ShimmerLoading();

  @override
  Widget build(BuildContext context) {
    AsyncValue<NotificationDetail> notificationData =
        ref.watch(notificationDetailProvider(widget.id));

    ref.watch(readNotificacionProvider(widget.id));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notificaciones',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: notificationData.when(
            data: (notification) {
              return ListView(
                shrinkWrap: true,
                children: [
                  Text(notification.title!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: black21,
                          fontSize: 16)),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(notification.sentDate!),
                      style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                  const SizedBox(
                    height: 8,
                  ),
                  SelectionArea(
                    child: Html(
                      data: notification.message,
                      onLinkTap: (url, _, __) async {
                        final Uri uri = Uri.parse(url!);
                        await launchUrl(uri, webOnlyWindowName: '_blank');
                      },
                    ),
                  ),
                  Divider(
                    height: 20,
                    color: Colors.grey[400],
                  ),
                  Text('Adjuntos',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: softGrey)),
                  const SizedBox(
                    height: 4,
                  ),
                  notification.haveAttachments!
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: notification.attachments?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _createItem(context, index,
                                notification.attachments![index]);
                          },
                        )
                      : Container(),
                ],
              );
            },
            error: (err, stack) => Container(),
            loading: () => _shimmerLoading.buildShimmerContent()),
      ),
    );
  }

  Widget _createItem(BuildContext context, index, Attachment attachment) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        final Uri uri =
            Uri.parse('${Environment.hostUrl}/${attachment.filepath}');
        await launchUrl(uri, webOnlyWindowName: '_blank');
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
                    Text(attachment.filename!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: black21)),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
