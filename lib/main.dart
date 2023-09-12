import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/firebase_options.dart';
import 'package:the_helper/src/app.dart';
import 'package:the_helper/src/features/notification/application/local_notification_service.dart';
import 'package:the_helper/src/utils/firebase_provider.dart';

void main() async {
  // Remove # in web app url. a.k.a localhost/#/home -> localhost/home
  // if (kIsWeb) {
  //   usePathUrlStrategy();
  // }
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  final firebase = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final localNotificationService = LocalNotificationService();
  await localNotificationService.setup();
  runApp(ProviderScope(
    overrides: [
      firebaseProvider.overrideWithValue(firebase),
      localNotificationServiceProvider
          .overrideWithValue(localNotificationService),
    ],
    child: const MyApp(),
  ));
}
