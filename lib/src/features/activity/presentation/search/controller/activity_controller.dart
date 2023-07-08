import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_include.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';

part 'activity_controller.g.dart';

final searchPatternProvider = StateProvider((ref) => '');
final hasUsedSearchProvider = StateProvider.autoDispose((ref) => false);

@riverpod
Future<List<Activity>> suggestedActivities(SuggestedActivitiesRef ref) async {
  return ref.watch(activityServiceProvider).getSuggestedActivities(
        query: ActivityQuery(limit: 5),
        include: ActivityInclude(
          organization: true,
          volunteers: true,
        ),
      );
}

final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    final activityService = ref.watch(activityServiceProvider);
    final controller = PagingController<int, Activity>(firstPageKey: 0);
    final searchPattern = ref.watch(searchPatternProvider);
    final hasUsedSearch = ref.watch(hasUsedSearchProvider);

    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await activityService.getActivities(
          query: ActivityQuery(
            limit: 5,
            offset: pageKey * 5,
            name: searchPattern,
          ),
          include: ActivityInclude(
            organization: true,
          ),
        );
        final isLastPage = items.length < 5;
        if (isLastPage) {
          controller.appendLastPage(items);
        } else {
          controller.appendPage(items, pageKey + 1);
        }
      } catch (err) {
        controller.error = err;
      }
    });
    // Controller do not refresh when input search pattern
    if (hasUsedSearch) {
      controller.notifyPageRequestListeners(0);
    }
    return controller;
  },
);
