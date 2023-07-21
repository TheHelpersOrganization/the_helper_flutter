import 'package:flutter/material.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/admin_manage/controllers/activity_manage_screen_controller.dart';
import 'package:the_helper/src/features/activity/presentation/admin_manage/widgets/activity_list_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../common/widget/error_widget.dart';
import '../../../../../common/widget/no_data_found.dart';
import '../../../domain/activity_status.dart';

class CustomScrollList extends StatelessWidget {
  final List<ActivityStatus> tabIndex;
  const CustomScrollList({
    super.key,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return RiverPagedBuilder<int, Activity>.autoDispose(
      firstPageKey: 0,
      provider: scrollPagingControlNotifier(tabIndex),
      pagedBuilder: (controller, builder) => PagedListView(
        pagingController: controller,
        builderDelegate: builder,
      ),
      itemBuilder: (context, item, index) => ActivityListItem(data: item),
      limit: 5,
      pullToRefresh: true,
      firstPageErrorIndicatorBuilder: (context, controller) =>
          CustomErrorWidget(
        onRetry: () => controller.retryLastFailedRequest(),
      ),
      newPageErrorIndicatorBuilder: (context, controller) => CustomErrorWidget(
        onRetry: () => controller.retryLastFailedRequest(),
      ),
      noItemsFoundIndicatorBuilder: (context, _) => const NoDataFound.simple(
        contentTitle: 'No activities found',
      ),
    );
  }
}
