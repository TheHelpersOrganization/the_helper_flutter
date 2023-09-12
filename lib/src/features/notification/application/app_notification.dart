import 'package:the_helper/src/features/notification/application/notification_service.dart';

class DownloadNotification {
  final NotificationService notificationService;
  final int id;
  final String filename;

  DownloadNotification({
    required this.notificationService,
    required this.id,
    required this.filename,
  });
}
