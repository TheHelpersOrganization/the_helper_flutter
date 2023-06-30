import 'dart:async';

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

  Future<List<NotificationModel>> getNotifications({
    NotificationQuery? query,
  }) async {
    final response = await client.get(
      '/notifications',
      queryParameters: query?.toJson(),
    );

    return (response.data['data'] as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }

  Future<int> countNotifications({
    NotificationQuery? query,
  }) async {
    final response = await client.get(
      '/notifications/count',
      queryParameters: query?.toJson(),
    );

    return response.data['data']['_count'] as int;
  }

  Future<NotificationModel> getNotificationById({
    required int id,
  }) async {
    final response = await client.get(
      '/notifications/$id',
    );

    return NotificationModel.fromJson(response.data['data']);
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

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepository(
    client: ref.watch(dioProvider),
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
      updateCount(res);
    });

    ref.onDispose(() {
      timer.cancel();
    });

    final res = await ref
        .watch(notificationRepositoryProvider)
        .countNotifications(query: NotificationQuery(read: false));
    return NotificationCount(count: res, updatedAt: DateTime.now());
  }

  void updateCount(int count) {
    if (state.isLoading) {
      return;
    }
    state = AsyncValue.data(
      NotificationCount(count: count, updatedAt: DateTime.now()),
    );
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
