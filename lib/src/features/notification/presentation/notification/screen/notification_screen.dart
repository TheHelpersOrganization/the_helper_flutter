import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/notification/application/notification_service.dart';
import 'package:the_helper/src/features/notification/domain/notification_model.dart';
import 'package:the_helper/src/features/notification/presentation/notification/controller/notification_controller.dart';
import 'package:the_helper/src/utils/image.dart';

class NotificationScreen extends ConsumerWidget {
  final int notificationId;

  const NotificationScreen({
    super.key,
    required this.notificationId,
  });

  Widget getNotificationTarget(
    BuildContext context,
    NotificationModel notification,
    NotificationService? notificationService,
  ) {
    Widget? leading = CircleAvatar(
      backgroundImage: getLogoProvider(),
    );
    String title;
    VoidCallback? onTap = notificationService == null
        ? null
        : () {
            notificationService.navigateOnNotificationClicked(
              notification,
              push: true,
            );
          };
    switch (notification.type) {
      case NotificationType.activity:
        title = notification.activity!.name!;
        leading = CircleAvatar(
          backgroundImage: getBackendImageOrLogoProvider(
            notification.activity!.thumbnail,
          ),
        );
        break;
      case NotificationType.shift:
        title = notification.shift!.name;
        leading = CircleAvatar(
          backgroundImage: getBackendImageOrLogoProvider(
            notification.activity!.thumbnail,
          ),
        );
        break;
      case NotificationType.organization:
        title = notification.organization!.name;
        leading = CircleAvatar(
          backgroundImage: getBackendImageOrLogoProvider(
            notification.organization!.logo,
          ),
        );
        break;

      case NotificationType.report:
        title = notification.report!.title;
        break;
      case NotificationType.system:
        title = 'System';
        break;
      case NotificationType.other:
        title = 'Other';
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leading,
      title: Text(title),
      subtitle: Text(
        notification.createdAt!.formatWeekDayDayMonthYearBulletHourMinute(),
        style: context.theme.textTheme.bodyMedium?.copyWith(
          color: context.theme.colorScheme.secondary,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider(notificationId));
    final notificationService =
        ref.watch(notificationServiceProvider).valueOrNull;

    return Scaffold(
      appBar: notificationState.isLoading
          ? null
          : AppBar(
              title: const Text('Notification'),
            ),
      body: notificationState.when(
        error: (_, __) => CustomErrorWidget(
          onRetry: () => ref.invalidate(notificationProvider(notificationId)),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        data: (notification) {
          if (notification == null) {
            return const DevelopingScreen();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notification.title,
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  getNotificationTarget(
                    context,
                    notification,
                    notificationService,
                  ),
                  const SizedBox(height: 24),
                  Text(notification.description),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
