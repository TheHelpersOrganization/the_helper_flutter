import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/activity/application/mod_activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/mod_activity_query.dart';
import 'package:the_helper/src/features/organization/data/current_organization_repository.dart';

import '../screen/mod_activity_list_management_screen.dart';

final currentStatusProvider =
    StateProvider.autoDispose((ref) => tabs.first.status);

final hasChangedStatusProvider = StateProvider.autoDispose((ref) => false);

final currentOrganizationProvider = FutureProvider.autoDispose((ref) =>
    ref.watch(currentOrganizationRepositoryProvider).getCurrentOrganization());

final pagingControllerProvider = FutureProvider.autoDispose(
  (ref) async {
    final hasChangedStatus = ref.watch(hasChangedStatusProvider);
    final currentStatus = ref.watch(currentStatusProvider);
    final modActivityService = ref.watch(modActivityServiceProvider);
    final controller = PagingController<int, Activity>(firstPageKey: 0);
    final org = await ref.watch(currentOrganizationProvider.future);

    if (org == null) {
      return controller;
    }

    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await modActivityService.getActivitiesWithOrganization(
          organizationId: org.id!,
          query: ModActivityQuery(
            offset: pageKey * 5,
            org: [org.id!],
          ),
        );
        final isLastPage = items.length < 100;
        if (isLastPage) {
          controller.appendLastPage(items);
        } else {
          controller.appendPage(items, pageKey + 1);
        }
      } catch (err) {
        controller.error = err;
      }
    });
    if (hasChangedStatus) {
      controller.notifyPageRequestListeners(0);
    }
    return controller;
  },
);
