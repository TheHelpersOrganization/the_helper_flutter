import 'package:flutter/material.dart';

import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/account/domain/account_request.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/widgets/custom_list_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/account/presentation/account_request_manage/controllers/account_request_manage_screen_controller.dart';

import '../../../../../common/widget/error_widget.dart';
import '../../../../../common/widget/no_data_found.dart';
import '../../../domain/account_request_query.dart';

class CustomScrollList extends StatelessWidget {
  final AccountRequestStatus tabIndex;
  const CustomScrollList({
    super.key,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return RiverPagedBuilder<int, AccountRequestModel>.autoDispose(
      firstPageKey: 0,
      provider: scrollPagingControlNotifier(tabIndex),
      pagedBuilder: (controller, builder) => PagedListView(
        pagingController: controller,
        builderDelegate: builder,
      ),
      itemBuilder: (context, item, index) => AccountRequestListItem(data: item),
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
