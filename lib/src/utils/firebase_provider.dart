import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseProvider = Provider<FirebaseApp>((ref) {
  throw UnimplementedError();
});

final firebaseMessagingProvider = FutureProvider<FirebaseMessaging>(
  (ref) async {
    final firebaseMessaging = FirebaseMessaging.instance;

    // Ignore firebase messaging on web
    if (kIsWeb) {
      return firebaseMessaging;
    }

    final perm = await firebaseMessaging.requestPermission();

    firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: perm.alert == AppleNotificationSetting.enabled,
      badge: perm.badge == AppleNotificationSetting.enabled,
      sound: perm.sound == AppleNotificationSetting.enabled,
    );

    return firebaseMessaging;
  },
);
