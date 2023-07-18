import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/presentation/chat_list/controller/chat_list_controller.dart';
import 'package:the_helper/src/features/chat/presentation/widget/chat_card.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListSocketState = ref.watch(chatListSocketProvider);
    final showSearch = ref.watch(showSearchProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final role = ref.watch(currentRoleProvider).valueOrNull;

    return Scaffold(
      drawer: const AppDrawer(),
      body: chatListSocketState.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => CustomErrorWidget(
          onRetry: () => ref.refresh(chatListSocketProvider),
        ),
        data: (data) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              leading: showSearch
                  ? BackButton(
                      onPressed: () => ref
                          .read(showSearchProvider.notifier)
                          .state = !showSearch,
                    )
                  : null,
              title: showSearch
                  ? DebounceSearchBar(
                      small: true,
                      initialValue: searchPattern,
                      debounceDuration: const Duration(seconds: 1),
                      onDebounce: (value) => ref
                          .read(searchPatternProvider.notifier)
                          .state = value.trim(),
                      onClear: () =>
                          ref.read(searchPatternProvider.notifier).state = '',
                    )
                  : Row(
                      children: [
                        const Text('Chats'),
                        const SizedBox(width: 12),
                        if (role == Role.admin)
                          Label(
                            labelText: 'Admin',
                            color: context.theme.primaryColor,
                          ),
                        if (role == Role.moderator)
                          const Label(
                            labelText: 'Moderator',
                            color: Colors.orange,
                          ),
                        if (role == Role.volunteer)
                          const Label(
                            labelText: 'Volunteer',
                            color: Colors.purple,
                          ),
                      ],
                    ),
              floating: true,
              actions: [
                IconButton(
                  onPressed: () {
                    ref.read(showSearchProvider.notifier).state = !showSearch;
                  },
                  icon: const Icon(Icons.search),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ],
          body: RiverPagedBuilder<int, Chat>.autoDispose(
            firstPageKey: 0,
            provider: chatListPagedNotifierProvider,
            pagedBuilder: (controller, builder) => PagedListView(
              pagingController: controller,
              builderDelegate: builder,
            ),
            itemBuilder: (context, chat, index) => ChatCard(chat: chat),
            limit: 20,
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
              contentTitle: 'No chat found',
            ),
          ),
        ),
      ),
    );
  }
}
