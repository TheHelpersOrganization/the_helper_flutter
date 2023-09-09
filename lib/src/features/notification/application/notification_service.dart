import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/authentication/domain/account_token.dart';
import 'package:the_helper/src/features/notification/data/notification_repository.dart';
import 'package:the_helper/src/features/notification/domain/notification_model.dart';
import 'package:the_helper/src/features/notification/domain/notification_query.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/firebase_provider.dart';

class NotificationService {
  final GoRouter router;
  final AuthService authService;
  final FirebaseMessaging firebaseMessaging;
  final localNotifications = FlutterLocalNotificationsPlugin();
  var _nextNotificationId = 0;
  int get nextNotificationId => _nextNotificationId++;

  NotificationService({
    required this.router,
    required this.authService,
    required this.firebaseMessaging,
  }) {
    setup();
  }

  Future<void> setup() async {
    if (kIsWeb) {
      return;
    }

    authService.addOnAfterSignInCallback(onAfterSignIn);
    authService.addOnAfterSignOutCallback(onAfterSignIn);

    firebaseMessaging.getInitialMessage().then((message) async {
      if (message == null) {
        return;
      }
      final notification = NotificationModel.fromJson(
        jsonDecode(message.data['notification']),
      );
      navigateOnNotificationClicked(notification);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      final notification = NotificationModel.fromJson(
        jsonDecode(message.data['notification']),
      );
      navigateOnNotificationClicked(notification);
    });
  }

  void onAfterSignIn(AccountToken? token) {
    if (token == null) {
      return;
    }
    firebaseMessaging.subscribeToTopic('all');
    firebaseMessaging.subscribeToTopic(
      'notification-account-${token.account.id}',
    );
  }

  void onAfterSignOut(AccountToken? token) {
    if (token == null) {
      return;
    }
    firebaseMessaging.unsubscribeFromTopic('all');
    firebaseMessaging.unsubscribeFromTopic(
      'notification-account-${token.account.id}',
    );
  }

  void navigateOnNotificationClicked(
    NotificationModel notification, {
    bool push = false,
  }) {
    switch (notification.type) {
      case NotificationType.activity:
        if (push) {
          router.pushNamed(AppRoute.activity.name, pathParameters: {
            'activityId': notification.activityId.toString(),
          });
        } else {
          router.goNamed(AppRoute.activity.name, pathParameters: {
            'activityId': notification.activityId.toString(),
          });
        }

        break;
      case NotificationType.shift:
        if (push) {
          router.pushNamed(AppRoute.shift.name, pathParameters: {
            'activityId': notification.activityId.toString(),
            'shiftId': notification.shiftId.toString(),
          });
        } else {
          router.goNamed(AppRoute.shift.name, pathParameters: {
            'activityId': notification.activityId.toString(),
            'shiftId': notification.shiftId.toString(),
          });
        }
        break;
      case NotificationType.organization:
        if (push) {
          router.pushNamed(AppRoute.organization.name, pathParameters: {
            'orgId': notification.organizationId.toString(),
          });
        } else {
          router.goNamed(AppRoute.organization.name, pathParameters: {
            'orgId': notification.organizationId.toString(),
          });
        }
        break;
      default:
        break;
    }
  }
}

final notificationServiceProvider = FutureProvider(
  (ref) async => NotificationService(
    router: ref.watch(routerProvider),
    authService: await ref.watch(authServiceProvider.notifier),
    firebaseMessaging: await ref.watch(firebaseMessagingProvider.future),
  ),
);

class NotificationCount {
  final int count;
  final DateTime updatedAt;

  NotificationCount({
    required this.count,
    required this.updatedAt,
  });
}

class NotificationCountNotifier extends AsyncNotifier<NotificationCount> {
  @override
  FutureOr<NotificationCount> build() async {
    final timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      state = const AsyncValue.loading();
      final res = await ref
          .read(notificationRepositoryProvider)
          .countNotifications(query: NotificationQuery(read: false));
      _internalUpdateCount(res);
    });

    ref.onDispose(() {
      timer.cancel();
    });

    final res = await ref
        .watch(notificationRepositoryProvider)
        .countNotifications(query: NotificationQuery(read: false));
    return NotificationCount(count: res, updatedAt: DateTime.now());
  }

  void _internalUpdateCount(int count) {
    state = AsyncValue.data(
      NotificationCount(count: count, updatedAt: DateTime.now()),
    );
  }

  void updateCount(int count) {
    if (state.isLoading) {
      return;
    }
    _internalUpdateCount(count);
  }

  void subtract([int value = 1]) {
    if (state.isLoading || !state.hasValue) {
      return;
    }
    final count = state.value!.count;
    state = AsyncValue.data(
      NotificationCount(count: count - value, updatedAt: DateTime.now()),
    );
  }
}

final notificationCountProvider =
    AsyncNotifierProvider<NotificationCountNotifier, NotificationCount>(
  () => NotificationCountNotifier(),
);
