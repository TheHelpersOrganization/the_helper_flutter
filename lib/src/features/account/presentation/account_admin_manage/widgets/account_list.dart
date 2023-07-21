import 'package:flutter/material.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/account/domain/account.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/widgets/active_account_list_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/controllers/account_manage_screen_controller.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/widgets/banned_account_list_item.dart';

import '../../../../../common/widget/error_widget.dart';
import '../../../../../common/widget/no_data_found.dart';

class AccountList extends StatelessWidget {
  final int tabIndex;
  const AccountList({
    super.key,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return RiverPagedBuilder<int, AccountModel>.autoDispose(
      firstPageKey: 0,
      provider: scrollPagingControlNotifier(tabIndex),
      pagedBuilder: (controller, builder) => PagedListView(
        pagingController: controller,
        builderDelegate: builder,
      ),
      itemBuilder: (context, item, index) {
        if(tabIndex == 0)
          {return ActiveAccountListItem(data: item, tabIndex: tabIndex,);}
        else {
          return BannedAccountListItem(data: item, tabIndex: tabIndex);
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
        contentTitle: 'No accounts found',
      ),
    );
  }
}
