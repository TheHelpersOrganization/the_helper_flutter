import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/notification/data/notification_repository.dart';
import 'package:the_helper/src/features/notification/domain/delete_notifications.dart';
import 'package:the_helper/src/features/notification/domain/mark_notifications_as_read.dart';
import 'package:the_helper/src/features/notification/domain/notification_model.dart';
import 'package:the_helper/src/features/notification/domain/notification_query.dart';
import 'package:the_helper/src/utils/async_value.dart';

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);

final isUnreadSelectedProvider =
    StateProvider.autoDispose<bool>((ref) => false);
final selectedNotificationIdsProvider =
    StateProvider.autoDispose<Set<int>>((ref) => {});

final isActivityNotificationSelectedProvider =
    StateProvider.autoDispose<bool>((ref) => false);
final isOrganizationNotificationSelectedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class NotificationListPagedNotifier
    extends PagedNotifier<int, NotificationModel> {
  final NotificationRepository notificationRepository;
  final bool unread;
  final String? searchPattern;
  final bool isActivityNotificationSelected;
  final bool isOrganizationNotificationSelected;

  NotificationListPagedNotifier({
    required this.notificationRepository,
    this.unread = false,
    this.searchPattern,
    this.isActivityNotificationSelected = false,
    this.isOrganizationNotificationSelected = false,
  }) : super(
          load: (page, limit) {
            final notificationType = <NotificationType>[];
            if (isActivityNotificationSelected) {
              notificationType.addAll(
                [
                  NotificationType.activity,
                  NotificationType.shift,
                ],
              );
            }
            if (isOrganizationNotificationSelected) {
              notificationType.add(NotificationType.organization);
            }
            return notificationRepository.getNotifications(
              query: NotificationQuery(
                limit: limit,
                offset: page * limit,
                read: unread == true ? false : null,
                name: searchPattern?.trim().isNotEmpty == true
                    ? searchPattern!.trim()
                    : null,
                type: notificationType.isEmpty ? null : notificationType,
                sort: [NotificationQuerySort.createdAtDesc],
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );

  void markAsRead(int notificationId) {
    final index = state.records
        ?.indexWhere((notification) => notification.id == notificationId);
    if (index == null || index < 0) {
      return;
    }
    final records = state.records!;
    records[index] = records[index].copyWith(read: true);
    state = state.copyWith(records: records);
  }
}

final notificationListPagedNotifierProvider = StateNotifierProvider.autoDispose<
    NotificationListPagedNotifier, PagedState<int, NotificationModel>>(
  (ref) => NotificationListPagedNotifier(
    notificationRepository: ref.watch(notificationRepositoryProvider),
    unread: ref.watch(isUnreadSelectedProvider),
    searchPattern: ref.watch(searchPatternProvider),
    isActivityNotificationSelected:
        ref.watch(isActivityNotificationSelectedProvider),
    isOrganizationNotificationSelected:
        ref.watch(isOrganizationNotificationSelectedProvider),
  ),
);

class MarkNotificationsAsReadController
    extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final NotificationRepository notificationRepository;

  MarkNotificationsAsReadController({
    required this.ref,
    required this.notificationRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> markNotificationsAsRead({
    required MarkNotificationsAsRead data,
    VoidCallback? onSuccess,
  }) async {
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => notificationRepository.markNotificationsAsRead(
        data: data,
      ),
    );
    if (res.hasError) {
      print(res.stackTrace);
      print(res.error);
    }
    if (!mounted) {
      return;
    }
    onSuccess?.call();
    state = res;
  }
}

final markNotificationsAsReadControllerProvider = StateNotifierProvider
    .autoDispose<MarkNotificationsAsReadController, AsyncValue<void>>(
  (ref) => MarkNotificationsAsReadController(
    ref: ref,
    notificationRepository: ref.watch(notificationRepositoryProvider),
  ),
);

class DeleteNotificationsController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final NotificationRepository notificationRepository;

  DeleteNotificationsController({
    required this.ref,
    required this.notificationRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> deleteNotifications({
    required DeleteNotifications data,
    VoidCallback? onSuccess,
  }) async {
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => notificationRepository.deleteNotifications(
        data: data,
      ),
    );
    if (!mounted) {
      return;
    }
    onSuccess?.call();
    state = res;
  }
}

final deleteNotificationsControllerProvider = StateNotifierProvider.autoDispose<
    DeleteNotificationsController, AsyncValue<void>>(
  (ref) => DeleteNotificationsController(
    ref: ref,
    notificationRepository: ref.watch(notificationRepositoryProvider),
  ),
);
