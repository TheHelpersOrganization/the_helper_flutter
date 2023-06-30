import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/notification/data/notification_repository.dart';
import 'package:the_helper/src/router/router.dart';

class NotificationButton extends ConsumerWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationCountData =
        ref.watch(notificationCountProvider).valueOrNull;
    final notificationCount = notificationCountData?.count;

    return IconButton(
      onPressed: () {
        context.pushNamed(AppRoute.notifications.name);
      },
      icon: Badge(
        label: Text(notificationCount.toString()),
        isLabelVisible: notificationCount != null && notificationCount > 0,
        child: const Icon(
          Icons.notifications_none_outlined,
        ),
      ),
    );
  }
}
