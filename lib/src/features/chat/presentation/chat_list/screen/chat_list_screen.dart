import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/presentation/chat_list/controller/chat_list_controller.dart';
import 'package:the_helper/src/features/chat/presentation/widget/chat_card.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('Chats'),
            centerTitle: true,
            floating: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
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
    );
  }
}
