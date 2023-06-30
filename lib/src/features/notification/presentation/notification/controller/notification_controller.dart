import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/notification/data/notification_repository.dart';
import 'package:the_helper/src/features/notification/domain/notification_model.dart';

final notificationProvider =
    FutureProvider.autoDispose.family<NotificationModel?, int>(
  (ref, id) => ref.watch(notificationRepositoryProvider).getNotificationById(
        id: id,
      ),
);
