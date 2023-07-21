import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_include.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_filter_controller.dart';
import 'package:the_helper/src/utils/paging.dart';

final showSearchProvider = StateProvider.autoDispose((ref) => false);
final searchPatternProvider = StateProvider.autoDispose((ref) => '');

final suggestedActivitiesProvider =
    FutureProvider.autoDispose.family<List<Activity>, int>(
  (ref, limit) => ref.watch(activityServiceProvider).getSuggestedActivities(
        query: ActivityQuery(limit: limit),
        include: ActivityInclude(
          organization: true,
          volunteers: true,
        ),
      ),
);

class ActivityListPagedNotifier extends PagedNotifier<int, Activity> {
  final ActivityService activityService;
  final String searchPattern;
  final ActivityQuery? query;

  ActivityListPagedNotifier({
    required this.activityService,
    required this.searchPattern,
    required this.query,
  }) : super(
          load: (page, limit) {
            print('page: $page, limit: $limit');
            int? cursor = page == 0 ? null : page;
            final q = query ?? ActivityQuery();
            return activityService.getActivities(
              query: q.copyWith(
                limit: limit,
                cursor: cursor,
                name: searchPattern,
              ),
              include: ActivityInclude(
                organization: true,
              ),
            );
          },
          nextPageKeyBuilder: cursorBasedPaginationNextKeyBuilder,
        );
}

final activityListPagedNotifierProvider = StateNotifierProvider.autoDispose<
    ActivityListPagedNotifier, PagedState<int, Activity>>(
  (ref) {
    final activityService = ref.watch(activityServiceProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final query = ref.watch(activityQueryProvider);
    return ActivityListPagedNotifier(
      activityService: activityService,
      searchPattern: searchPattern,
      query: query,
    );
  },
);
