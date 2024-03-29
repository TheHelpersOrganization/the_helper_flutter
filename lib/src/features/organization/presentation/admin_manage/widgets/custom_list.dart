import 'package:flutter/material.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/organization/presentation/admin_manage/controllers/organization_manage_screen_controller.dart';

import '../../../../../common/widget/error_widget.dart';
import '../../../../../common/widget/no_data_found.dart';
import '../../../domain/admin_organization.dart';
import 'active_list_item.dart';
import 'banned_list_item.dart';

class CustomScrollList extends StatelessWidget {
  final bool tabIndex;
  const CustomScrollList({
    super.key,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return RiverPagedBuilder<int, AdminOrganization>.autoDispose(
      firstPageKey: 0,
      provider: scrollPagingControlNotifier(tabIndex),
      pagedBuilder: (controller, builder) => PagedListView(
        pagingController: controller,
        builderDelegate: builder,
      ),
      itemBuilder: (context, item, index) {
        if (tabIndex) {
          return BannedOrganizationListItem(data: item);
        } else {
          return ActiveOrganizationListItem(data: item);
        }
      },
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
        contentTitle: 'No organization found',
      ),
    );
  }
}
