import 'package:flutter/material.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization/presentation/admin_manage/widgets/custom_item_list.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/organization/presentation/admin_manage/controllers/organization_manage_screen_controller.dart';

import '../../../../../common/widget/error_widget.dart';
import '../../../../../common/widget/no_data_found.dart';
import '../../../domain/organization_status.dart';

class CustomScrollList extends StatelessWidget {
  final OrganizationStatus tabIndex;
  const CustomScrollList({
    super.key,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return RiverPagedBuilder<int, Organization>.autoDispose(
      firstPageKey: 0,
      provider: scrollPagingControlNotifier(tabIndex),
      pagedBuilder: (controller, builder) => PagedListView(
        pagingController: controller,
        builderDelegate: builder,
      ),
      itemBuilder: (context, item, index) {
        return CustomListItem(data: item);
        // if (tabIndex == OrganizationStatus.pending) {
        //   return PendingListItem(data: item);
        // } else if (tabIndex == OrganizationStatus.verified) {
        //   return VerifiedListItem(data: item);
        // } else if (tabIndex == OrganizationStatus.cancelled) {
        //   return CancelledListItem(data: item);
        // } else {
        //   return RejectListItem(data: item);
        // }
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
        contentTitle: 'No requests found',
      ),
    );
  }
}
