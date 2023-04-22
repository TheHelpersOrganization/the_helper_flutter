import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_card/activity_card.dart';

class ActivityList extends ConsumerWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = ref.watch(pagingControllerProvider);

    return PagedListView<int, Activity>(
      shrinkWrap: true,
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) => ActivityCard(
          activity: item,
        ),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: NoDataFound(
            contentTitle: 'No organization was found',
            contentSubtitle: 'Please try other search terms',
          ),
        ),
      ),
    );
  }
}
