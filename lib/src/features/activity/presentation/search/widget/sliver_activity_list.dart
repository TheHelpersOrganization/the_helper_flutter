import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_card/activity_card.dart';

class SliverActivityList extends ConsumerWidget {
  const SliverActivityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = ref.watch(pagingControllerProvider);

    return PagedSliverList<int, Activity>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) => ActivityCard(
          activity: item,
        ),
        firstPageProgressIndicatorBuilder: (context) => const SizedBox(
          height: 200,
          child: SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: double.infinity,
              height: 200,
            ),
          ),
        ),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: NoDataFound(
            contentTitle: 'No activity was found',
            contentSubtitle: 'Please try other search terms',
          ),
        ),
      ),
    );
  }
}
