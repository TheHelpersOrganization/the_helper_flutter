import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';

import '../../domain/organization.dart';
import 'organization_card.dart';
import 'organization_search_controller.dart';

class OrganizationListWidget extends ConsumerWidget {
  const OrganizationListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RiverPagedBuilder<int, Organization>.autoDispose(
      provider: organizationListPagedNotifierProvider,
      pagedBuilder: (controller, builder) => PagedListView(
        pagingController: controller,
        builderDelegate: builder,
      ),
      itemBuilder: (context, item, index) => OrganizationCard(
        organization: item,
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
      firstPageErrorIndicatorBuilder: (context, controller) =>
          CustomErrorWidget(
        onRetry: () => controller.retryLastFailedRequest(),
      ),
      noItemsFoundIndicatorBuilder: (context, _) => const Center(
        child: NoDataFound(
          contentTitle: 'No organizations was found',
          contentSubtitle: 'Please try other search terms',
        ),
      ),
    );
  }
}
