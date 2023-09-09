import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<void Function(NotificationResponse details)>
    _backgroundNotificationClickedCallbacks = [];

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  // Prevent concurrent modification
  final callbacks = _backgroundNotificationClickedCallbacks.toList();
  for (final callback in callbacks) {
    callback(details);
  }
}

class LocalNotificationService {
  final localNotifications = FlutterLocalNotificationsPlugin();
  final List<void Function(NotificationResponse details)>
      _notificationClickedCallbacks = [];
  var _nextNotificationId = 0;

  int nextNotificationId() {
    return _nextNotificationId++;
  }

  Future<void> setup() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Prevent concurrent modification
        final callbacks = _notificationClickedCallbacks.toList();
        for (final callback in callbacks) {
          callback(details);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  void addOnNotificationClickedCallback(
      void Function(NotificationResponse details) callback) {
    _notificationClickedCallbacks.add(callback);
  }

  void removeOnNotificationClickedCallback(
      void Function(NotificationResponse details) callback) {
    _notificationClickedCallbacks.remove(callback);
  }

  void addOnBackgroundNotificationClickedCallback(
      void Function(NotificationResponse details) callback) {
    _backgroundNotificationClickedCallbacks.add(callback);
  }

  void removeOnBackgroundNotificationClickedCallback(
      void Function(NotificationResponse details) callback) {
    _backgroundNotificationClickedCallbacks.remove(callback);
  }

  void addOnNotificationClickedCallbackOnce(
      void Function(NotificationResponse details) callback) {
    void Function(NotificationResponse details)? callback0;
    callback0 = (details) {
      callback(details);
      removeOnNotificationClickedCallback(callback0!);
    };
    addOnNotificationClickedCallback(callback0);
  }

  void addOnBackgroundNotificationClickedCallbackOnce(
      void Function(NotificationResponse details) callback) {
    void Function(NotificationResponse details)? callback0;
    callback0 = (details) {
      callback(details);
      removeOnBackgroundNotificationClickedCallback(callback0!);
    };
    addOnBackgroundNotificationClickedCallback(callback0);
  }

  Future<void> ensureNotificationPermission() async {
    if (kIsWeb) {
      return;
    }
    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  Future<int> createNotification({
    String? title,
    String? body,
    String? payload,
    NotificationDetails? notificationDetails,
  }) async {
    await ensureNotificationPermission();
    final id = nextNotificationId();
    await localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    return id;
  }

  Future<void> updateNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    NotificationDetails? notificationDetails,
  }) async {
    await ensureNotificationPermission();
    await localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> cancelNotification({required int id}) async {
    await localNotifications.cancel(id);
  }
}

final localNotificationServiceProvider =
    Provider<LocalNotificationService>((ref) {
  throw UnimplementedError();
});
