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
    String? token = await firebaseMessaging.getToken(
      vapidKey:
          'BCCdlA5ISTX_ijiL-mJrSL1n32QA-c0LdIiThzx7dxLZix_KwD5A0nav1tBCpMRjPTCINbUtFGB_aH1XReqeb_s',
    );
    print('FirebaseMessaging token: $token');
    firebaseMessaging.subscribeToTopic('all');
    FirebaseMessaging.onBackgroundMessage((message) async {
      print(message.toMap());
    });
    FirebaseMessaging.onMessage.listen((message) async {
      print(message.toMap());
    });
    firebaseMessaging.getInitialMessage().then((message) async {
      print(message?.toMap());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print(message.toMap());
    });
    firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: perm.alert == AppleNotificationSetting.enabled,
      badge: perm.badge == AppleNotificationSetting.enabled,
      sound: perm.sound == AppleNotificationSetting.enabled,
    );
    return firebaseMessaging;
  },
);
