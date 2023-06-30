import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/authentication/domain/account_token.dart';
import 'package:the_helper/src/utils/firebase_provider.dart';

class AppService {
  final AccountToken? accountToken;
  final FirebaseApp firebaseApp;
  final FirebaseMessaging firebaseMessaging;

  const AppService({
    required this.accountToken,
    required this.firebaseApp,
    required this.firebaseMessaging,
  });
}

final appServiceProvider = FutureProvider((ref) async {
  final authServiceFuture = ref.watch(authServiceProvider.future);
  final firebaseAppFuture = await ref.watch(firebaseProvider.future);
  final firebaseMessagingFuture = ref.watch(firebaseMessagingProvider.future);

  return AppService(
    accountToken: await authServiceFuture,
    firebaseApp: firebaseAppFuture,
    firebaseMessaging: await firebaseMessagingFuture,
  );
});
