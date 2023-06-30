import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/notification/data/notification_repository.dart';
import 'package:the_helper/src/features/notification/domain/delete_notifications.dart';
import 'package:the_helper/src/features/notification/domain/mark_notifications_as_read.dart';
import 'package:the_helper/src/features/notification/domain/notification_model.dart';
import 'package:the_helper/src/features/notification/presentation/notification_list/controller/notification_list_controller.dart';
import 'package:the_helper/src/features/notification/presentation/notification_list/widget/notification_card.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final isUnreadSelected = ref.watch(isUnreadSelectedProvider);
    final selectedNotificationIds = ref.watch(selectedNotificationIdsProvider);
    final notifications =
        ref.watch(notificationListPagedNotifierProvider).records;
    final notificationCount = notifications?.length;
    final hasNotification = notificationCount != null && notificationCount > 0;
    final hasSelectedNotifications = selectedNotificationIds.isNotEmpty;

    final markNotificationsAsReadState =
        ref.watch(markNotificationsAsReadControllerProvider);
    final deleteNotificationsState =
        ref.watch(deleteNotificationsControllerProvider);

    final isActivityNotificationSelected =
        ref.watch(isActivityNotificationSelectedProvider);
    final isOrganizationNotificationSelected =
        ref.watch(isOrganizationNotificationSelectedProvider);

    ref.listen<AsyncValue>(
      markNotificationsAsReadControllerProvider,
      (previous, next) {
        next.showSnackbarOnError(context);
        next.showSnackbarOnSuccess(
          context,
          content: const Text('Marked notifications as read'),
        );
      },
    );

    ref.listen<AsyncValue>(
      deleteNotificationsControllerProvider,
      (previous, next) {
        next.showSnackbarOnError(context);
        next.showSnackbarOnSuccess(
          context,
          content: const Text('Deleted notifications'),
        );
      },
    );

    return LoadingOverlay.customDarken(
      isLoading: deleteNotificationsState.isLoading ||
          markNotificationsAsReadState.isLoading,
      indicator: const LoadingDialog(
        titleText: 'Please wait',
      ),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              title: Text(
                hasSelectedNotifications
                    ? '${selectedNotificationIds.length} selected'
                    : 'Notifications',
              ),
              floating: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ref.read(isSearchingProvider.notifier).state = !isSearching;
                  },
                ),
                PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert_outlined,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: hasNotification,
                      child: Row(
                        children: [
                          const Icon(Icons.mark_chat_read_outlined),
                          const SizedBox(width: 8),
                          Text(
                            'Mark ${hasSelectedNotifications ? "selected" : "all"} as read',
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                            titleText: 'Mark notification as read',
                            contentColumnChildren: [
                              Text.rich(
                                TextSpan(
                                  text: 'Are you sure you want to mark ',
                                  children: [
                                    TextSpan(
                                      text:
                                          '${hasSelectedNotifications ? "selected" : "all"} notifications',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: ' as read?'),
                                  ],
                                ),
                              ),
                            ],
                            showActionCanNotBeUndoneText: true,
                            onConfirm: () {
                              if (!hasNotification) {
                                return;
                              }
                              context.navigator.pop();
                              List<int> ids = hasSelectedNotifications
                                  ? selectedNotificationIds.toList()
                                  : notifications!.map((e) => e.id).toList();
                              int unreadCount = 0;
                              for (final notification in notifications!) {
                                if (ids.contains(notification.id) &&
                                    !notification.read) {
                                  unreadCount++;
                                }
                              }
                              ref
                                  .read(
                                      markNotificationsAsReadControllerProvider
                                          .notifier)
                                  .markNotificationsAsRead(
                                    data: MarkNotificationsAsRead(
                                      id: ids,
                                    ),
                                    onSuccess: () {
                                      ref.invalidate(
                                        notificationListPagedNotifierProvider,
                                      );
                                      ref.invalidate(notificationCountProvider);
                                      ref
                                          .read(selectedNotificationIdsProvider
                                              .notifier)
                                          .state = {};
                                      ref
                                          .read(notificationCountProvider
                                              .notifier)
                                          .subtract(unreadCount);
                                    },
                                  );
                            },
                          ),
                        );
                      },
                    ),
                    PopupMenuItem(
                      enabled: hasNotification,
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline),
                          const SizedBox(width: 8),
                          Text(
                            'Delete ${hasSelectedNotifications ? "selected" : "all"}',
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                            titleText: 'Delete notification',
                            contentColumnChildren: [
                              Text.rich(
                                TextSpan(
                                  text: 'Are you sure you want to delete ',
                                  children: [
                                    TextSpan(
                                      text:
                                          '${hasSelectedNotifications ? "selected" : "all"} notifications?',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onConfirm: () {
                              if (!hasNotification) {
                                return;
                              }
                              context.navigator.pop();
                              List<int> ids = hasSelectedNotifications
                                  ? selectedNotificationIds.toList()
                                  : notifications!.map((e) => e.id).toList();
                              int unreadCount = 0;
                              for (final notification in notifications!) {
                                if (ids.contains(notification.id) &&
                                    !notification.read) {
                                  unreadCount++;
                                }
                              }
                              ref
                                  .read(deleteNotificationsControllerProvider
                                      .notifier)
                                  .deleteNotifications(
                                    data: DeleteNotifications(
                                      id: ids,
                                    ),
                                    onSuccess: () {
                                      ref.invalidate(
                                        notificationListPagedNotifierProvider,
                                      );
                                      ref.invalidate(notificationCountProvider);
                                      ref
                                          .read(selectedNotificationIdsProvider
                                              .notifier)
                                          .state = {};
                                      ref
                                          .read(notificationCountProvider
                                              .notifier)
                                          .subtract(unreadCount);
                                    },
                                  );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (isSearching)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: DebounceSearchBar(
                    hintText: 'Search notifications',
                    debounceDuration: const Duration(seconds: 1),
                    small: true,
                    onDebounce: (value) {
                      ref.read(searchPatternProvider.notifier).state =
                          value.trim().isNotEmpty ? value.trim() : null;
                      ref.read(selectedNotificationIdsProvider.notifier).state =
                          {};
                    },
                    onClear: () {
                      ref.read(searchPatternProvider.notifier).state = null;
                      ref.read(selectedNotificationIdsProvider.notifier).state =
                          {};
                    },
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Unread'),
                      selected: isUnreadSelected,
                      onSelected: (value) {
                        ref.read(isUnreadSelectedProvider.notifier).state =
                            value;
                        ref
                            .read(selectedNotificationIdsProvider.notifier)
                            .state = {};
                      },
                    ),
                    FilterChip(
                      label: const Text('Activity'),
                      selected: isActivityNotificationSelected,
                      onSelected: (value) {
                        ref
                            .read(
                                isActivityNotificationSelectedProvider.notifier)
                            .state = value;
                        ref
                            .read(selectedNotificationIdsProvider.notifier)
                            .state = {};
                      },
                    ),
                    FilterChip(
                      label: const Text('Organization'),
                      selected: isOrganizationNotificationSelected,
                      onSelected: (value) {
                        ref
                            .read(isOrganizationNotificationSelectedProvider
                                .notifier)
                            .state = value;
                        ref
                            .read(selectedNotificationIdsProvider.notifier)
                            .state = {};
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (notificationCount != null && notificationCount > 0)
              SliverToBoxAdapter(
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Select all'),
                  value: notificationCount > 0 &&
                      selectedNotificationIds.length == notificationCount,
                  onChanged: (value) {
                    if (value == true) {
                      ref.read(selectedNotificationIdsProvider.notifier).state =
                          {
                        ...notifications!.map((e) => e.id).toList(),
                      };
                    } else {
                      ref.read(selectedNotificationIdsProvider.notifier).state =
                          {};
                    }
                  },
                ),
              ),
          ],
          body: RiverPagedBuilder<int, NotificationModel>.autoDispose(
            firstPageKey: 0,
            provider: notificationListPagedNotifierProvider,
            pagedBuilder: (controller, builder) => PagedListView(
              pagingController: controller,
              builderDelegate: builder,
            ),
            itemBuilder: (context, notification, index) =>
                NotificationCard(notification: notification),
            limit: 5,
            pullToRefresh: true,
            firstPageErrorIndicatorBuilder: (context, controller) =>
                CustomErrorWidget(
              onRetry: () => controller.retryLastFailedRequest(),
            ),
            newPageErrorIndicatorBuilder: (context, controller) =>
                CustomErrorWidget(
              onRetry: () => controller.retryLastFailedRequest(),
            ),
            noItemsFoundIndicatorBuilder: (context, _) =>
                const NoDataFound.simple(
              contentTitle: 'No notifications found',
            ),
          ),
        ),
      ),
    );
  }
}
