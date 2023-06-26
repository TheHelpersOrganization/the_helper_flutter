import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/notification/domain/delete_notifications.dart';
import 'package:the_helper/src/features/notification/domain/mark_notifications_as_read.dart';
import 'package:the_helper/src/features/notification/domain/notification_model.dart';
import 'package:the_helper/src/features/notification/domain/notification_query.dart';
import 'package:the_helper/src/utils/dio.dart';

class NotificationRepository {
  final Dio client;

  NotificationRepository({
    required this.client,
  });

  Future<List<NotificationModel>> getNotifications(
      {NotificationQuery? query}) async {
    final response = await client.get(
      '/notifications',
      queryParameters: query?.toJson(),
    );

    return (response.data['data'] as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }

  Future<List<NotificationModel>> markNotificationsAsRead({
    required MarkNotificationsAsRead data,
  }) async {
    final response = await client.put(
      '/notifications/mark-as-read',
      data: data.toJson(),
    );

    return (response.data['data'] as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }

  Future<List<NotificationModel>> deleteNotifications({
    required DeleteNotifications data,
  }) async {
    final response = await client.delete(
      '/notifications',
      data: data.toJson(),
    );

    return (response.data['data'] as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }
}

final notificationRepositoryProvider =
    Provider.autoDispose<NotificationRepository>(
  (ref) => NotificationRepository(
    client: ref.watch(dioProvider),
  ),
);
