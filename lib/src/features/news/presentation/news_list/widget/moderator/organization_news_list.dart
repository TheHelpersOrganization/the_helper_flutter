import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/news/presentation/common/widget/news_card.dart';
import 'package:the_helper/src/features/news/presentation/news_list/controller/news_list_mod_controller.dart';

class OrganizationNewsList extends StatelessWidget {
  const OrganizationNewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return RiverPagedBuilder.autoDispose(
      provider: organizationNewsListPagedNotifierProvider,
      pagedBuilder: (controller, builder) => PagedSliverList(
        pagingController: controller,
        builderDelegate: builder,
      ),
      itemBuilder: (context, item, index) => NewsCard(
        news: item,
        viewMode: Role.moderator,
      ),
      firstPageKey: 0,
    );
  }
}
