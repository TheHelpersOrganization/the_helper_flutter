import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';

part 'volunteer_home_controller.g.dart';

@riverpod
Future<List<Activity>> suggestedActivities(SuggestedActivitiesRef ref) async {
  return ref.watch(activityServiceProvider).getSuggestedActivities(
        query: ActivityQuery(limit: 5),
      );
}

final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    final activityService = ref.watch(activityServiceProvider);
    final controller = PagingController<int, Activity>(firstPageKey: 0);

    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await activityService.getActivities(
          query: ActivityQuery(
            limit: 5,
            offset: pageKey,
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
