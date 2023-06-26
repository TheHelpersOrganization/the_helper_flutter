import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/notification/domain/notification_model.dart';
import 'package:the_helper/src/features/notification/presentation/notification_list/controller/notification_list_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/image.dart';

class NotificationCard extends ConsumerWidget {
  final NotificationModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotificationIds = ref.watch(selectedNotificationIdsProvider);
    final isSelected = selectedNotificationIds.contains(notification.id);

    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.grey.shade200,
      leading: isSelected
          ? const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.check_outlined,
                color: Colors.white,
              ),
            )
          : CircleAvatar(
              backgroundImage: getLogoProvider(),
            ),
      title: Text(notification.title),
      titleTextStyle: context.theme.textTheme.bodyLarge?.copyWith(
        fontWeight: notification.read ? null : FontWeight.bold,
      ),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            notification.createdAt!.formatDayMonthYearBulletHourMinute(),
            style: TextStyle(
              color: context.theme.colorScheme.secondary,
              fontWeight: notification.read ? null : FontWeight.bold,
            ),
          ),
          Text(
            notification.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      onTap: () {
        context.goNamed(AppRoute.notification.name, pathParameters: {
          'notificationId': notification.id.toString(),
        });
      },
      onLongPress: () {
        if (isSelected) {
          ref.read(selectedNotificationIdsProvider.notifier).state = {
            ...selectedNotificationIds..remove(notification.id)
          };
          return;
        }
        ref.read(selectedNotificationIdsProvider.notifier).state = {
          ...selectedNotificationIds..add(notification.id)
        };
      },
    );
  }
}
