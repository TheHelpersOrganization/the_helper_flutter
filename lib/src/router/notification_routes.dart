import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/notification/presentation/notification/screen/notification_screen.dart';
import 'package:the_helper/src/features/notification/presentation/notification_list/screen/notification_list_screen.dart';
import 'package:the_helper/src/router/router.dart';

final notificationRoutes = GoRoute(
  path: AppRoute.notifications.path,
  name: AppRoute.notifications.name,
  builder: (context, state) => const NotificationListScreen(),
  routes: [
    GoRoute(
      path: AppRoute.notification.path,
      name: AppRoute.notification.name,
      builder: (context, state) => NotificationScreen(
        notificationId: int.parse(
          state.pathParameters['notificationId']!,
        ),
      ),
    ),
  ],
);
