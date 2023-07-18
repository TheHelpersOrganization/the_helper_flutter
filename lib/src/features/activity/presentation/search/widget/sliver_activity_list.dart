import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_card/activity_card.dart';

class SliverActivityList extends ConsumerWidget {
  const SliverActivityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RiverPagedBuilder<int, Activity>.autoDispose(
      provider: activityListPagedNotifierProvider,
      pagedBuilder: (controller, builder) => PagedSliverList(
        pagingController: controller,
        builderDelegate: builder,
      ),
      itemBuilder: (context, item, index) => ActivityCard(
        activity: item,
      ),
      firstPageKey: 0,
      firstPageProgressIndicatorBuilder: (context, _) => const SizedBox(
        height: 200,
        child: SkeletonAvatar(
          style: SkeletonAvatarStyle(
            width: double.infinity,
            height: 200,
          ),
        ),
      ),
      noItemsFoundIndicatorBuilder: (context, _) => const Center(
        child: NoDataFound(
          contentTitle: 'No activity was found',
          contentSubtitle: 'Please try other search terms',
        ),
      ),
    );
  }
}
