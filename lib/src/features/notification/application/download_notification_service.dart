import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:the_helper/src/features/notification/application/local_notification_service.dart';

const AndroidNotificationDetails downloadAndroidNotificationDetails =
    AndroidNotificationDetails(
  'download',
  'Download',
  channelDescription: 'Show download progress',
  importance: Importance.low,
  priority: Priority.high,
  ticker: 'ticker',
  onlyAlertOnce: true,
  showProgress: true,
);

class DownloadNotificationService {
  final LocalNotificationService localNotificationService;

  DownloadNotificationService({
    required this.localNotificationService,
  }) {
    localNotificationService.addOnNotificationClickedCallback(callback);
  }

  void callback(NotificationResponse details) async {
    if (details.payload == null) {
      return;
    }
    print('payload: ${details.payload}');
    OpenFile.open(details.payload!);
  }

  void dispose() {
    localNotificationService.removeOnNotificationClickedCallback(callback);
  }

  Future<int> createDownloadNotification({
    required String filename,
  }) async {
    const NotificationDetails notificationDetails =
        NotificationDetails(android: downloadAndroidNotificationDetails);
    return localNotificationService.createNotification(
      title: filename,
      body: 'Downloading $filename',
      notificationDetails: notificationDetails,
    );
  }

  Future<void> updateDownloadNotification({
    required int id,
    required String filename,
    required String folderPath,
    required double progress,
  }) async {
    final progressPercent = (progress * 100).toInt();
    const NotificationDetails notificationDetails =
        NotificationDetails(android: downloadAndroidNotificationDetails);
    String? payload;
    if (progressPercent >= 100) {
      payload = folderPath;
    }
    return localNotificationService.updateNotification(
      id: id,
      title: progressPercent >= 100 ? 'Download finished' : 'Downloading',
      body: progressPercent >= 100
          ? '$filename has been downloaded'
          : '$filename is being downloaded',
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  Future<void> updateDownloadNotificationAsFailed({
    required int id,
    required String filename,
  }) async {
    const NotificationDetails notificationDetails =
        NotificationDetails(android: downloadAndroidNotificationDetails);
    return localNotificationService.updateNotification(
      id: id,
      title: 'Download failed',
      body: 'Failed to download $filename',
      notificationDetails: notificationDetails,
    );
  }
}

final downloadNotificationServiceProvider =
    Provider<DownloadNotificationService>((ref) {
  final service = DownloadNotificationService(
    localNotificationService: ref.watch(localNotificationServiceProvider),
  );
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});
