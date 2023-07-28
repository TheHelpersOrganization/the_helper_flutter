import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/activity/application/mod_activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/activity/domain/mod_activity_query.dart';
import 'package:the_helper/src/features/organization/data/current_organization_repository.dart';

import '../screen/mod_activity_list_management_screen.dart';

final isSearchingProvider = StateProvider.autoDispose((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);

final currentStatusProvider =
    StateProvider.autoDispose((ref) => tabs.first.status);

final currentOrganizationProvider = FutureProvider.autoDispose((ref) =>
    ref.watch(currentOrganizationRepositoryProvider).getCurrentOrganization());

final isManagerProvider = StateProvider.autoDispose((ref) => false);
final isShiftManagerProvider = StateProvider.autoDispose((ref) => false);

final pagingControllerProvider = FutureProvider.autoDispose(
  (ref) async {
    final currentStatus = ref.watch(currentStatusProvider);
    final modActivityService = ref.watch(modActivityServiceProvider);
    final controller = PagingController<int, Activity>(firstPageKey: 0);
    final org = await ref.watch(currentOrganizationProvider.future);
    final isManager = ref.watch(isManagerProvider);
    final isShiftManager = ref.watch(isShiftManagerProvider);
    final searchPattern = ref.watch(searchPatternProvider)?.trim();

    if (org == null) {
      return controller;
    }

    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await modActivityService.getActivitiesWithOrganization(
          organizationId: org.id,
          query: ModActivityQuery(
            name: searchPattern?.isNotEmpty == true ? searchPattern : null,
            offset: pageKey * 5,
            org: [org.id],
            status: [currentStatus],
            isManager: isManager,
            isShiftManager: isShiftManager,
            sort: [ActivityQuerySort.startTimeAsc],
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
    return controller;
  },
);
