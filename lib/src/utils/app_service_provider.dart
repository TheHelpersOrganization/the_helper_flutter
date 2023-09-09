import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/authentication/domain/account_token.dart';
import 'package:the_helper/src/features/notification/application/notification_service.dart';
import 'package:the_helper/src/utils/firebase_provider.dart';

class AppService {
  final AccountToken? accountToken;
  final FirebaseApp firebaseApp;
  final FirebaseMessaging firebaseMessaging;
  final NotificationService notificationService;

  const AppService({
    required this.accountToken,
    required this.firebaseApp,
    required this.firebaseMessaging,
    required this.notificationService,
  });
}

final appServiceProvider = FutureProvider((ref) async {
  final authServiceFuture = await ref.watch(authServiceProvider.future);
  final firebaseApp = ref.watch(firebaseProvider);
  final firebaseMessagingFuture =
      await ref.watch(firebaseMessagingProvider.future);
  final notificationService =
      await ref.watch(notificationServiceProvider.future);

  return AppService(
    accountToken: authServiceFuture,
    firebaseApp: firebaseApp,
    firebaseMessaging: firebaseMessagingFuture,
    notificationService: notificationService,
  );
});
