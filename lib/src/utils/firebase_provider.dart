import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/firebase_options.dart';

final firebaseProvider = FutureProvider((ref) async {
  return await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
});

final firebaseMessagingProvider = FutureProvider<FirebaseMessaging>(
  (ref) async {
    await ref.watch(firebaseProvider.future);
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
